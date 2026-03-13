

##########################
# AWS region
##########################
variable "aws_region" {
  description = "AWS region to deploy resources in"
  type        = string
}


##########################
# project_prefix for resource identification
##########################
variable "project_prefix" {
  description = "the name of the vpc"
  type        = string
}


##########################
# EC2 instance type
##########################
variable "instance_type" {
  description = "EC2 instance type for the ASG"
  type        = string
}

##########################
# Number of EC2s in ASG
##########################
variable "number_of_ec2s" {
  description = "Desired number of EC2s"
  type        = number
}

variable "min_ec2" {
  description = "Minimum number of EC2s in ASG"
  type        = number
}

variable "max_ec2" {
  description = "Maximum number of EC2s in ASG"
  type        = number
}

##########################
# EC2 user data script
##########################
variable "ec2_user_data" {
  description = "Path to EC2 user data template"
  type        = string
}


##########################
# SSH KEY PAIR
##########################
variable "key_name" {
  description = "Path to EC2 user data template"
  type        = string
}
