variable "vpc_id" {}
variable "cidr_block" {}
variable "igw_id" {}
variable "natgw_id" {}

variable "pub_subnet_id" {}
variable "pri_subnet_id" {}


resource "aws_route_table" "igw_route_table" {
  vpc_id = var.vpc_id
  route {
    cidr_block = var.cidr_block
    gateway_id = var.igw_id
  }
  tags = {
    "Name" = "custom_igw_table"
  }
}

resource "aws_route_table_association" "public_igw_rt_assoc" {
  depends_on = [aws_route_table.igw_route_table,]
  subnet_id      = var.pub_subnet_id
  route_table_id = aws_route_table.igw_route_table.id
}

resource "aws_route_table" "natgw_route_table" {
  vpc_id = var.vpc_id
  route {
    cidr_block = var.cidr_block
    nat_gateway_id  = var.natgw_id
  }
  tags = {
    "Name" = "custom_ngw_table"
  }
}

resource "aws_route_table_association" "private_natgw_rt_assoc" {
  depends_on = [aws_route_table.natgw_route_table,]
  subnet_id      = var.pri_subnet_id
  route_table_id = aws_route_table.natgw_route_table.id
}