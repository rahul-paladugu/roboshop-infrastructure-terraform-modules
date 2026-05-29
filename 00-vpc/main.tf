module "roboshop_vpc" {
  source = "git::https://github.com/rahul-paladugu/Terraform-module-aws-vpc.git"
  cidr_block = var.cidr_block
  project = var.project
  environment = var.environment
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  database_subnet_cidrs = var.database_subnet_cidrs
  az_names = var.az_names
  internet_cidr = var.internet_cidr
}