suvariable "db" {}
variable "wp" {}
variable "priv_key" {}

resource "null_resource" "wp_setup" {
  depends_on = [var.db, var.wp,]
  connection {
    type        = "ssh"
    user        = "ec2-user"
    host        = var.wp.public_ip
    port        = 22
    private_key = var.priv_key
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2",
      "sudo yum install -y httpd php-gd",
      "wget https://wordpress.org/latest.tar.gz",
      "tar -xzf latest.tar.gz",
      "cp wordpress/wp-config-sample.php wordpress/wp-config.php",
      "sed -i 's/database_name_here/wordpress_db/g' wordpress/wp-config.php",
      "sed -i 's/username_here/wordpress_user/g' wordpress/wp-config.php",
      "sed -i 's/password_here/testpassword/g' wordpress/wp-config.php",
      "sed -i 's/localhost/${var.db.private_ip}/g' wordpress/wp-config.php",
      "sudo cp -r wordpress/* /var/www/html/",
      "sudo chown -R apache /var/www",
      "sudo chgrp -R apache /var/www",
      "sudo chmod 2775 /var/www",
      "sudo sed -i  '151s/.*/AllowOverride All/' httpd.conf",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd"
    ]
  }
}