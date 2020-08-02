variable "cidr" {}
variable "subnet_az" {}
variable "map_public_ip" {}
variable "vpc_id" {}
variable "name_tag" {}

resource "aws_subnet" "subnet_gen" {
  cidr_block              = var.cidr
  availability_zone       = var.subnet_az
  map_public_ip_on_launch = var.map_public_ip
  vpc_id                  = var.vpc_id
  tags = {
    Name = var.name_tag
  }
}

output "subnet_id" {
   value =aws_subnet.subnet_gen.id
}