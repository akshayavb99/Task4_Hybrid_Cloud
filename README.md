# Working with Terraform and AWS - Part IV
This repository contains all the files used to complete Task 4 of Hybrid Multi Cloud Computing.
In this project, the main objective is to work in Amazon Web Services (AWS) to host WordPress and MariaDB database on different AWS EC2 instances, to increase the security of sensitive user data stored in MariaDB.
In the process, we will also set up other network components offered by AWS like VPC, subnets, gateways etc.

The files in this repository will help you create the following resources on AWS:
- One Virtual Private Network (VPC)
- Two subnets (one with internet connectivity and the other with no internet connectivity
- Internet Gateway
- NAT Gateway
- Elastic IP
- AWS EC2 instances - one for WordPress and one for MariaDB
- Respective Security Groups and a private key

The code is written in HCL, and the entire setup can be directly cloned from the master branch of the repository. To complete the setup, make the necessary changes in the **main.tf** and **variable.tf** like the AWS profile, CIDR blocks for the VPC and subnets etc.
Once the changes have been made, execute the following commands on the CLI:
```
   terraform init
   terraform plan
   terraform validate
   terraform apply --auto-approve
```
Note that **services like NAT Gateways are paid, so once you have tested your project, immediately delete all the resources** using the command
```
terraform destroy --auto-approve
```
