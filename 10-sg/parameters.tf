resource "aws_ssm_parameter" "sg_id" {
    count = length(var.components)
  name  = "/${var.project}/${var.environment}/${var.components[count.index]}/sg_id"
  type  = "String"
  value = module.roboshop_security_group[count.index].sg_id
  overwrite = true
}
