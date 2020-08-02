provider "aws" {
  profile = var.profile_name
  region  = var.region_name
}

module "key_gen" {
   source = "./my_key"
   key_name = "task4_key"
}

module "vpc_gen" {
   source = "./my_vpc"
   vpc_cidr = var.vpc_cidr
   vpc_tag_name = var.vpc_tag_name
}

module "public_subnet" {
   source = "./my_subnet"
   subnet_az = var.pub_subnet_az
   cidr = "${var.subnets["${var.pub_subnet_az}"]}"
   map_public_ip = "true"
   vpc_id = module.vpc_gen.vpc.id
   name_tag = "public_subnet"
}

module "private_subnet" {
   source = "./my_subnet"
   subnet_az = var.pri_subnet_az
   cidr = "${var.subnets["${var.pri_subnet_az}"]}"
   map_public_ip = "false"
   vpc_id = module.vpc_gen.vpc.id
   name_tag = "private_subnet"
}

module "gateways_eip" {
  source = "./my_gateways"
  vpc_id = module.vpc_gen.vpc.id
  igw_name = "custom_igw"
  natgw_eip_name = "custom_natgw_eip"
  public_subnet_id = module.public_subnet.subnet_id
  natgw_name = "custom_natgw"
}

module "igw_route_table" {
  source = "./my_route_tables"
  vpc_id = module.vpc_gen.vpc.id
  cidr_block = "0.0.0.0/0"
  igw_id = module.gateways_eip.igw_id
  natgw_id = module.gateways_eip.natgw_id
  pub_subnet_id = module.public_subnet.subnet_id
  pri_subnet_id = module.private_subnet.subnet_id
}

module "sgs" {
  source = "./my_sg"
  vpc_id = module.vpc_gen.vpc.id
  vpc_cidr = module.vpc_gen.vpc.cidr_block
}

/*data "aws_ami" "aws_linux_2" {
  executable_users = ["self"]
  most_recent      = true
  owners = ["amazon","aws-marketplace"]

  filter {
    name = "image-id"
    values = ["ami-0732b62d310b80e97"]
  }

}

output "ami_desc" {
  value = data.aws_ami.aws_linux_2.description
}*/

module "wp_inst" {
  source = "./my_ec2/wp_inst"
  ami = "ami-0ebc1ac48dfd14136" # Amazon Linux 2 AMI (HVM), SSD Volume Type
  inst_type = "t2.micro"
  key_name = module.key_gen.key_name
  sg_id = module.sgs.wp_sg_id
  subnet_id = module.public_subnet.subnet_id
}

module "db_inst" {
  source = "./my_ec2/sql_inst"
  ami = "ami-0ebc1ac48dfd14136" # Amazon Linux 2 AMI (HVM), SSD Volume Type
  inst_type = "t2.micro"
  key_name = module.key_gen.key_name
  sg_id = module.sgs.db_sg_id
  subnet_id = module.private_subnet.subnet_id
  wp_private_ip = module.wp_inst.wp.private_ip
}

module "integrate" {
  source = "./my_ec2"
  db = module.db_inst.db
  wp = module.wp_inst.wp
  priv_key = module.key_gen.priv_key
}



output "wp_inst_ip" {
  value = module.wp_inst.wp.public_ip
}
