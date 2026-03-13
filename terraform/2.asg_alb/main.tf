provider "aws" {
  region = var.aws_region
}

# Reference pre-provisioned infrastructure
data "terraform_remote_state" "infra" {
  backend = "local"
  config = {
    path = "../1.permanent_infra/terraform.tfstate"
  }
}

# -----------------------------
# Locals for cleaner references
# -----------------------------
locals {
  vpc_id  = data.terraform_remote_state.infra.outputs.vpc_id
  subnets = data.terraform_remote_state.infra.outputs.public_subnets
  sg_id   = data.terraform_remote_state.infra.outputs.security_group_id
}

# -----------------------------
# obtain ami_id dynamically
# -----------------------------
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    #values = ["amzn2-ami-hvm-*-x86_64-gp2"]
    values = ["al2023-ami-2023*-x86_64"]
  }
}



# -----------------------------
# Launch Template
# -----------------------------

resource "aws_launch_template" "web_template" {

  name_prefix   = "${var.project_prefix}-template"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  key_name = var.key_name

  # Assign public IP like the working aws_instance example
  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [local.sg_id]
  }

  # Encode user data to Base64
  user_data = base64encode(templatefile(var.ec2_user_data,{}))
  #user_data = base64encode(templatefile(var.ec2_user_data, {}))

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.project_prefix}-ec2"
      Role = "webserver"
    }
  }
}



# -----------------------------
# Auto Scaling Group
# -----------------------------
resource "aws_autoscaling_group" "web_asg" {
  name             = "${var.project_prefix}-asg"
  max_size         = var.max_ec2
  min_size         = var.min_ec2
  desired_capacity = var.number_of_ec2s
  launch_template {
    id      = aws_launch_template.web_template.id
    version = "$Latest"
  }
  vpc_zone_identifier       = local.subnets
  health_check_type         = "EC2"
  health_check_grace_period = 60
  force_delete              = true

  # Register all ASG instances into this ALB target group automatically.
  target_group_arns = [aws_lb_target_group.app.arn]
}

# -----------------------------
# Target Tracking Scaling Policy
# Automatically scales ASG to maintain target CPU utilization
# -----------------------------
resource "aws_autoscaling_policy" "target_tracking_cpu" {
  name                      = "${var.project_prefix}_cpu_target_tracking"
  policy_type               = "TargetTrackingScaling"
  estimated_instance_warmup = 60
  autoscaling_group_name    = aws_autoscaling_group.web_asg.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 20.0
  }
}

