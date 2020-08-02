variable "vpc_id" {}
variable "igw_name" {}

variable "natgw_eip_name" {}

variable "public_subnet_id" {}
variable "natgw_name" {}

resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id
  tags = {
    Name = var.igw_name
  }
}

resource "aws_eip" "natgw_eip" {
  vpc = true
  tags = {
    Name = var.natgw_eip_name
  }
}

resource "aws_nat_gateway" "natgw" {
  depends_on = [aws_eip.natgw_eip,]
  allocation_id = aws_eip.natgw_eip.id
  subnet_id     = var.public_subnet_id
  tags = {
    Name = var.natgw_name
  }
}

output "igw_id" {
   value = aws_internet_gateway.igw.id
}

output "natgw_id" {
   value = aws_nat_gateway.natgw.id
}