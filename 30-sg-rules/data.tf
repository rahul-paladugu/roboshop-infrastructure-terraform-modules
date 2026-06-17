data "aws_ssm_parameter" "frontend_sg_id" {
  name = "/${var.project}/${var.environment}/frontend/sg_id"
}

data "aws_ssm_parameter" "frontend_alb_sg_id" {
  name = "/${var.project}/${var.environment}/frontend-alb/sg_id"
}

data "aws_ssm_parameter" "backend_alb_sg_id" {
  name = "/${var.project}/${var.environment}/backend-alb/sg_id"
}

data "aws_ssm_parameter" "bastion_sg_id" {
  name = "/${var.project}/${var.environment}/bastion/sg_id"
}

data "aws_ssm_parameter" "mongodb_sg_id" {
  name = "/${var.project}/${var.environment}/mongodb/sg_id"
}

data "aws_ssm_parameter" "redis_sg_id" {
  name = "/${var.project}/${var.environment}/redis/sg_id"
}

data "aws_ssm_parameter" "mysql_sg_id" {
  name = "/${var.project}/${var.environment}/mysql/sg_id"
}

data "aws_ssm_parameter" "rabbitmq_sg_id" {
  name = "/${var.project}/${var.environment}/rabbitmq/sg_id"
}

data "aws_ssm_parameter" "catalogue_sg_id" {
  name = "/${var.project}/${var.environment}/catalogue/sg_id"
}