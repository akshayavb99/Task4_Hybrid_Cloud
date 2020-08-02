variable "vpc_id" {}
variable "vpc_cidr" {}

resource "aws_security_group" "wp_sg" {
  name        = "wp_sg"
  description = "SG for Wordpress instances"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow all HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
    description = "Allow all SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name = "wp_sg"
  }

}

resource "aws_security_group" "db_sg" {
  name        = "db_sg"
  description = "SG for Database (SQL) instances"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow SQL DB Access only in given CIDR block"
    from_port   = 3306
    to_port     = 3306
    protocol    = "TCP"
    cidr_blocks = [var.vpc_cidr,]
  }

  ingress {
    description = "Allow all SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#--------- OUTPUTS FOR BOTH SECURITY GROUPS ---------#

output "wp_sg_id"{
  value = aws_security_group.wp_sg.id
}

output "db_sg_id"{
  value = aws_security_group.db_sg.id
}