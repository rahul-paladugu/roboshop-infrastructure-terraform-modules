locals {
  ami_id = data.aws_ami.roboshop_ami.id
  common_name = "${var.environment}-${var.project}"
  catalogue_sg_id = data.aws_ssm_parameter.catalogue_sg_id.value
  private_subnet_id = split("," , data.aws_ssm_parameter.private_subnet_ids.value )[0]
  common_tags = {
    Terraform = "True"
  }
  remote_user =  data.aws_ssm_parameter.remote_user.value
  remote_user_password = data.aws_ssm_parameter.remote_user_password.value
  zone_id = data.aws_route53_zone.roboshop_r53.zone_id
  r53_common_name = "rscloudservices.icu"
}
