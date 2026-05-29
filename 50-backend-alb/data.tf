
data "aws_ssm_parameter" "backend_alb_sg_id" {
  name = "/backend-alb-${var.environment}-${var.project}/sg_id"
}


data "aws_ssm_parameter" "public_subnet_ids" {
  name = "/${var.project}-${var.environment}-public_subnet_ids"
}
