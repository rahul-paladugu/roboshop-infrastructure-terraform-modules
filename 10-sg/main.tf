module "roboshop_security_group" {
  count = length(var.components)
  source = "git::https://github.com/rahul-paladugu/Terraform-module-aws-sg.git"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  environment = var.environment
  project = var.project
  components = var.components[count.index]
  sg_description = "${var.components[count.index]}-security-group"
  sg_name = "${var.components[count.index]}-${var.environment}-${var.project}-sg"
}

