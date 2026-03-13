terraform {
  required_version = ">= 1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}


provider "aws" {
  region = "eu-central-1"
}

##########################
# VPC CONFIGURATION
##########################
# Using the official AWS VPC module to create a simple VPC with two public subnets
module "vpc" {
  
  #module source
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.5.0"

  name = "${var.project_prefix}_vpc"

  cidr = var.vpc_cidr

  azs            = var.az_list
  #creating this public subnet creates an internet gateway automatically
  #and so grants internet access
  public_subnets = var.pub_subnet_cidr

  enable_nat_gateway      = false
  single_nat_gateway      = false
  enable_dns_hostnames    = true
  enable_dns_support      = true
  
  map_public_ip_on_launch = true
}



##########################
# SECURITY GROUP
##########################
# Allows SSH and NFS traffic between EC2 instances and EFS
resource "aws_security_group" "ec2_sg" {
#######
  name        = "${var.project_prefix}_sg"
  description = "Allow SSH, HTTPS and NFS"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "SSH access from anywhere"
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # we make this more restrictive later
  }

  #for apache2 access
  ingress {
    description = "8080 for apache2"
    from_port   = var.apache2_port
    to_port     = var.apache2_port
    protocol    = "tcp"
    #cidr_blocks = [module.vpc.vpc_cidr_block] # within this cidr block. only intranet
    cidr_blocks = ["0.0.0.0/0"] # open to the internet
  }

#https
ingress {
    description = "HTTPS access within the VPC"
    from_port   = var.https_port
    to_port     = var.https_port
    protocol    = "tcp"
    #cidr_blocks = [module.vpc.vpc_cidr_block]
    cidr_blocks = ["0.0.0.0/0"] # we make this more restrictive later
  }

  ingress {
    description = "HTTPS access within the VPC"
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = "tcp"
    #cidr_blocks = [module.vpc.vpc_cidr_block]
    cidr_blocks = ["0.0.0.0/0"] # we make this more restrictive later
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

