
data "aws_ssm_parameter" "backend_alb_sg_id" {
  name = "/${var.project}/${var.environment}/backend-alb/sg_id"
}


data "aws_ssm_parameter" "public_subnet_ids" {
  name = "/${var.project}/${var.environment}/public_subnet_ids"
}

data "aws_route53_zone" "roboshop_r53" {
  name         = "rscloudservices.icu"
  private_zone = false
}