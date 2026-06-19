resource "aws_ssm_parameter" "acm_certificate" {
  name  = "/${var.project}/${var.environment}/certificate_arn"
  type  = "String"
  value = aws_acm_certificate_validation.roboshop.certificate_arn
  overwrite = true
}
