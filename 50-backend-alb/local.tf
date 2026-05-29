locals {
  common_name = "${var.environment}-${var.project}"
  backend_alb_sg_id = data.aws_ssm_parameter.backend_alb_sg_id.value
  public_subnet_ids = split("," , data.aws_ssm_parameter.public_subnet_ids.value )
  common_tags = {
    Terraform = "True"
  }
}
