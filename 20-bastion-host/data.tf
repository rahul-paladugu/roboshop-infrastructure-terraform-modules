data "aws_ssm_parameter" "sg_id" {
  name = "/bastion-${var.environment}-${var.project}/sg_id"
}

data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.project}-${var.environment}/vpc_id"
}

data "aws_ssm_parameter" "public_subnet_ids" {
  name = "/${var.project}-${var.environment}-public_subnet_ids"
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
