output "sg" {
  value = zipmap(var.components, module.roboshop_security_group[*].sg_id)
}
