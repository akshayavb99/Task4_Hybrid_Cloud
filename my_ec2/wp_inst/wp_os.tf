variable "ami" {}
variable "inst_type" {}
variable "key_name" {}
variable "sg_id" {}
variable "subnet_id" {}


resource "aws_instance" "wp_os" {
  ami             = var.ami
  instance_type   = var.inst_type
  key_name        = var.key_name
  vpc_security_group_ids = [var.sg_id,]
  subnet_id       = var.subnet_id
  
  tags = {
    Name = "wp_os"
  }
}

output "wp" {
  value = aws_instance.wp_os
}

