resource "aws_ssm_parameter" "backend_alb_arn" {
  name  = "/${var.project}/${var.environment}/backend-alb-arn"
  type  = "String"
  value = aws_lb.backend_alb.arn
  overwrite = true
}
