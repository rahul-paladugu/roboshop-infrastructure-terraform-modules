output "vpc" {
  value = module.roboshop_vpc.vpc_id
}

output "public_subnet_id" {
  value = module.roboshop_vpc.public_subnets
}