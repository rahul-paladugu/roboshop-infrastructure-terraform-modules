#Backend ALB ARN Stored in SSM Parameter Store
resource "aws_ssm_parameter" "backend_alb_arn" {
  name  = "/${var.project}/${var.environment}/backend-alb-arn"
  type  = "String"
  value = aws_lb.backend_alb.arn
  overwrite = true
}
#Backend ALB Listener ARN Stored in SSM Parameter Store
resource "aws_ssm_parameter" "backend_alb_listener_arn" {
  name  = "/${var.project}/${var.environment}/backend-alb-listener-arn"
  type  = "String"
  value = aws_lb_listener.backend_alb.arn
  overwrite = true
}