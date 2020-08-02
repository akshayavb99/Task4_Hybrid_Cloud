variable "vpc_tag_name" {}
variable "vpc_cidr" {}

resource "aws_vpc" "vpc_gen" {
  cidr_block            = var.vpc_cidr
  enable_dns_support    = true
  enable_dns_hostnames  = true
  tags = {
    Name = var.vpc_tag_name
  }
}

output "vpc" {
   value = aws_vpc.vpc_gen
}