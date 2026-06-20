data "aws_ssm_parameter" "catalogue_sg_id" {
  name = "/${var.project}/${var.environment}/catalogue/sg_id"
}


data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.project}/${var.environment}/vpc_id"
}

data "aws_ssm_parameter" "private_subnet_ids" {
  name = "/${var.project}/${var.environment}/private_subnet_ids"
}

data "aws_ssm_parameter" "remote_user" {
  name = "/remote-user-${var.project}"
}

data "aws_ssm_parameter" "remote_user_password" {
  name = "/remote-user-password-${var.project}"
}

data "aws_ssm_parameter" "backend_alb_arn" {
  name = "/${var.project}/${var.environment}/backend-alb-arn"
}

data "aws_ssm_parameter" "backend_alb_listener_arn" {
  name = "/${var.project}/${var.environment}/backend-alb-listener-arn"
}

data "aws_ami" "roboshop_ami" {
  most_recent      = true
  owners           = ["973714476881"]

  filter {
    name   = "name"
    values = ["Redhat-9-DevOps-Practice"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_route53_zone" "roboshop_r53" {
  name         = "rscloudservices.icu"
  private_zone = false
}
