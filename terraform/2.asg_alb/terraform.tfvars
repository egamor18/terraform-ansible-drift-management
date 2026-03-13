project_prefix = "ansible-terraform-project"
aws_region     = "eu-central-1"

instance_type  = "t3.micro"
number_of_ec2s = 0
min_ec2        = 0
max_ec2        = 20
ec2_user_data  = "./user_data.sh.tmpl"

key_name ="jenkins_ssh_key_pair"
