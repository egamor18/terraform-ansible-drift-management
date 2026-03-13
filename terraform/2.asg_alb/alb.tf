
#--------------------------------------------------------

############################################
# Application Load Balancer
############################################

resource "aws_lb" "this" {
  name               = "${var.project_prefix}-alb"
  load_balancer_type = "application"

  security_groups = [local.sg_id]
  subnets         = local.subnets
}

############################################
# Target Group
############################################

resource "aws_lb_target_group" "app" {
  name     = "${var.project_prefix}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = local.vpc_id

  health_check {
    path = "/"
  }
}

############################################
# Listener
############################################

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}


