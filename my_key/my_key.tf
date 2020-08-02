variable "key_name" {}

# Generates RSA Keypair
resource "tls_private_key" "task4_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Save Private key locally
resource "local_file" "task4_key_pem" {
  content  = tls_private_key.task4_key.private_key_pem
  filename = "./${var.key_name}.pem"
}

# Upload public key to create keypair on AWS
resource "aws_key_pair" "task4_key" {
  key_name   = var.key_name
  public_key = tls_private_key.task4_key.public_key_openssh
}

output "key_name" {
  value = aws_key_pair.task4_key.key_name
}

output "priv_key" {
  value = tls_private_key.task4_key.private_key_pem
}