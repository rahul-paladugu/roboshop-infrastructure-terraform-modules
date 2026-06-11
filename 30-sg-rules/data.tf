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

data "aws_ssm_parameter" "redis_sg_id" {
  name = "/redis-${var.environment}-${var.project}/sg_id"
}

data "aws_ssm_parameter" "mysql_sg_id" {
  name = "/mysql-${var.environment}-${var.project}/sg_id"
}

data "aws_ssm_parameter" "rabbitmq_sg_id" {
  name = "/rabbitmq-${var.environment}-${var.project}/sg_id"
}

data "aws_ssm_parameter" "catalogue_sg_id" {
  name = "/catalogue-${var.environment}-${var.project}/sg_id"
}