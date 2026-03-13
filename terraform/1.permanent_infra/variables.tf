
#--------------------VPC CONFIG VARIABLES ---------------------

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
# VPC name
##########################
variable "vpc_cidr" {
  description = "the name of the vpc"
  type        = string
}



##########################
# AZ's
##########################
variable "az_list" {
  description = "list of availability zones"
  type        = list
}



##########################
# public subnets cidr ranges
##########################
variable "pub_subnet_cidr" {
  description = "cidr range for public subnets"
  type        = list
}


#--------------SECURITY GROUP CONFIG VARIABLES ---------------

##########################
# ssh port
##########################
variable "ssh_port" {
  description = "ssh port"
  type        = number
}

##########################
# https
##########################
variable "https_port" {
  description = "https port number"
  type        = number
}


##########################
# http
##########################
variable "http_port" {
  description = "http port number"
  type        = number
}

##########################
# apache2 port 8080
##########################
variable "apache2_port" {
  description = "nginx port number"
  type        = number
}

#-----------------------------------------------------------

