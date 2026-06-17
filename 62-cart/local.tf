locals {
  ami_id = data.aws_ami.roboshop_ami.id
  common_name = "${var.environment}-${var.project}"
  cart_sg_id = data.aws_ssm_parameter.cart_sg_id.value
  private_subnet_id = split("," , data.aws_ssm_parameter.private_subnet_ids.value )[0]
  common_tags = {
    Terraform = "True"
  }
  remote_user =  data.aws_ssm_parameter.remote_user.value
  remote_user_password = data.aws_ssm_parameter.remote_user_password.value
  zone_id = data.aws_route53_zone.roboshop_r53.zone_id
  r53_common_name = "rscloudservices.icu"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  asg_tags = {
    Name = "cart-${var.environment}-${var.project}-asg"
    Terraform = "True"
    environment = var.environment
  }
  private_subnet_id_1 = split("," , data.aws_ssm_parameter.private_subnet_ids.value )[0]
  private_subnet_id_2 = split("," , data.aws_ssm_parameter.private_subnet_ids.value )[1]

}
