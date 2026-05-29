locals {
  frontend_sg_id = data.aws_ssm_parameter.frontend_sg_id.value
  frontend_alb_sg_id = data.aws_ssm_parameter.frontend_alb_sg_id.value
  backend_alb_sg_id = data.aws_ssm_parameter.backend_alb_sg_id.value
  bastion_sg_id = data.aws_ssm_parameter.bastion_sg_id.value
  mongodb_sg_id = data.aws_ssm_parameter.mongodb_sg_id.value
}