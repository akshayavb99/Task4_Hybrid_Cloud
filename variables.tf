#------------ VARIABLES FOR CONFIGURING AWS PROFILE -------------#

variable "profile_name" {
  type = string
  default = "iam_akshaya"
}

variable "region_name" {
  type = string
  default = "ap-south-1"
}

#------------ VARIABLES FOR VPC -------------#

variable "vpc_cidr" {
  type = string
  default = "192.168.0.0/16"
}

variable "vpc_tag_name" {
  type = string
  default = "vpc_custom"
}

#------------ VARIABLES FOR SUBNETS -------------#

variable "subnets" {
  type = map(string)
  default = {
    "ap-south-1a" = "192.168.0.0/24"
    "ap-south-1b" = "192.168.1.0/24"
  }
}

#------------ VARIABLES FOR PUBLIC SUBNET -------------#

variable "pub_subnet_az" {
  type = string
  default = "ap-south-1a"
}

#------------ VARIABLES FOR PRIVATE SUBNET -------------#

variable "pri_subnet_az" {
  type = string
  default = "ap-south-1b"
}

#------------ VARIABLES FOR GATEWAYS AND ELASTIC IP -------------#


