data "aws_ssm_parameter" "mongodb_sg_id" {
  name = "/mongodb-${var.environment}-${var.project}/sg_id"
}

data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.project}-${var.environment}/vpc_id"
}

data "aws_ssm_parameter" "database_subnet_ids" {
  name = "/${var.project}-${var.environment}-database_subnet_ids"
}

data "aws_ssm_parameter" "remote_user" {
  name = "/remote-user-${var.project}"
}

data "aws_ssm_parameter" "remote_user_password" {
  name = "/remote-user-password-${var.project}"
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
