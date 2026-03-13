aws_region = "eu-central-1"
project_prefix = "ansible-terraform-project"
vpc_cidr = "10.0.0.0/16"
az_list =  ["eu-central-1a", "eu-central-1b"]
pub_subnet_cidr = ["10.0.1.0/24", "10.0.2.0/24"]


#-------security group values-----
ssh_port = 22
https_port = 443
http_port  =80
apache2_port =8080