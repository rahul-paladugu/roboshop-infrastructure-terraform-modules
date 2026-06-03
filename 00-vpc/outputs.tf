output "vpc" {
  value = module.roboshop_vpc.vpc_id
}

output "public_subnet_id" {
  value = module.roboshop_vpc.public_subnets
}

output "private_subnet_id" {
  value = module.roboshop_vpc.private_subnets
}

output "database_subnet_id" {
  value = module.roboshop_vpc.database_subnets
}