output "sg" {
  value = module.roboshop_security_group[*].sg_id
}

output "public_subnet_ids" {
  value = module.roboshop_security_group
}