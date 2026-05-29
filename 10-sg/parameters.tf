resource "aws_ssm_parameter" "sg_id" {
    count = length(var.components)
  name  = "/${var.components[count.index]}-${var.environment}-${var.project}/sg_id"
  type  = "String"
  value = module.roboshop_security_group[count.index].sg_id
}
