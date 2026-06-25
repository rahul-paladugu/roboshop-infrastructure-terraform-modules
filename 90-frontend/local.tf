locals {
  ami_id = data.aws_ami.roboshop_ami.id
  common_name = "${var.environment}-${var.project}"
  frontend_sg_id = data.aws_ssm_parameter.frontend_sg_id.value
  public_subnet_id = split("," , data.aws_ssm_parameter.public_subnet_ids.value )[0]
  common_tags = {
    Terraform = "True"
  }
  remote_user =  data.aws_ssm_parameter.remote_user.value
  remote_user_password = data.aws_ssm_parameter.remote_user_password.value
  zone_id = data.aws_route53_zone.roboshop_r53.zone_id
  r53_common_name = "rscloudservices.icu"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  asg_tags = {
    Name = "frontend-${var.environment}-${var.project}"
    Terraform = "True"
    environment = var.environment
  }
  public_subnet_id_1 = split("," , data.aws_ssm_parameter.public_subnet_ids.value )[0]
  public_subnet_id_2 = split("," , data.aws_ssm_parameter.public_subnet_ids.value )[1]
  frontend_alb_arn = data.aws_ssm_parameter.frontend_alb_arn.value
  frontend_alb_listener_arn = data.aws_ssm_parameter.frontend_alb_listener_arn.value
}
