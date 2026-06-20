#Frontend ALB ARN Stored in SSM Parameter Store
resource "aws_ssm_parameter" "frontend_alb_arn" {
  name  = "/${var.project}/${var.environment}/frontend-alb-arn"
  type  = "String"
  value = aws_lb.frontend_alb.arn
  overwrite = true
}
#Frontend ALB Listener ARN Stored in SSM Parameter Store
resource "aws_ssm_parameter" "frontend_alb_listener_arn" {
  name  = "/${var.project}/${var.environment}/frontend-alb-listener-arn"
  type  = "String"
  value = aws_lb_listener.frontend_alb.arn
  overwrite = true
}