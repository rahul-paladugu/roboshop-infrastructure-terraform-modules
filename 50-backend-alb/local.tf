locals {
  common_name = "${var.environment}-${var.project}"
  backend_alb_sg_id = data.aws_ssm_parameter.backend_alb_sg_id.value
  public_subnet_ids = split("," , data.aws_ssm_parameter.public_subnet_ids.value )
  zone_id = data.aws_route53_zone.roboshop_r53.zone_id
  r53_common_name = "rscloudservices.icu"
  common_tags = {
    Terraform = "True"
  }
}
