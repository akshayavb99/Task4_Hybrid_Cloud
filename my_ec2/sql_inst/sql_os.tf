variable "ami" {}
variable "inst_type" {
  type = string
  default = "t2.small"
}
variable "key_name" {}
variable "sg_id" {}
variable "subnet_id" {}
variable "wp_private_ip" {}


resource "aws_instance" "db_inst" {
  ami             = var.ami
  instance_type   = var.inst_type
  key_name        = var.key_name
  vpc_security_group_ids = [var.sg_id,]
  subnet_id       = var.subnet_id
  
  user_data       = <<EOT
    #!/bin/bash
    sudo yum update -y
    sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
    sudo yum install -y mariadb-server
    sudo systemctl start mariadb
    sudo systemctl enable mariadb
    mysql -u root <<EOF
      CREATE USER 'wordpress-user'@'${var.wp_private_ip}' IDENTIFIED BY 'testpassword';
      CREATE DATABASE wordpress_db;
      GRANT ALL PRIVILEGES ON wordpress_db.* TO 'wordpress-user'@'${var.wp_private_ip}';
      FLUSH PRIVILEGES;
      exit
     EOF
    EOT
  
  tags = {
    Name = "sql_os"
  }
}

output "db" {
  value = aws_instance.db_inst
}