data "aws_ssm_parameter" "frontend_sg_id" {
  name = "/frontend-${var.environment}-${var.project}/sg_id"
}

data "aws_ssm_parameter" "frontend_alb_sg_id" {
  name = "/frontend-alb-${var.environment}-${var.project}/sg_id"
}

data "aws_ssm_parameter" "backend_alb_sg_id" {
  name = "/backend-alb-${var.environment}-${var.project}/sg_id"
}

data "aws_ssm_parameter" "bastion_sg_id" {
  name = "/bastion-${var.environment}-${var.project}/sg_id"
}

data "aws_ssm_parameter" "mongodb_sg_id" {
  name = "/mongodb-${var.environment}-${var.project}/sg_id"
}