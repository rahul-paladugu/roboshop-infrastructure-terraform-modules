resource "aws_ssm_parameter" "vpc_id" {
  name  = "/${var.project}-${var.environment}/vpc_id"
  type  = "String"
  value = module.roboshop_vpc.vpc_id
  overwrite = true
}

resource "aws_ssm_parameter" "public_subnet_ids" {
  name  = "/${var.project}-${var.environment}-public_subnet_ids"
  type  = "StringList"
  value = join("," , module.roboshop_vpc.public_subnets)
  overwrite = true
}

resource "aws_ssm_parameter" "private_subnet_ids" {
  name  = "/${var.project}-${var.environment}-private_subnet_ids"
  type  = "StringList"
  value = join("," , module.roboshop_vpc.private_subnets)
  overwrite = true
}

resource "aws_ssm_parameter" "database_subnet_ids" {
  name  = "/${var.project}-${var.environment}-database_subnet_ids"
  type  = "StringList"
  value = join("," , module.roboshop_vpc.database_subnets)
  overwrite = true
}

resource "aws_ssm_parameter" "eip" {
  name  = "/${var.project}-${var.environment}-eip"
  type  = "String"
  value = module.roboshop_vpc.eip_id
  overwrite = true
}

resource "aws_ssm_parameter" "igw" {
  name  = "/${var.project}-${var.environment}-igw"
  type  = "String"
  value = module.roboshop_vpc.igw_id
  overwrite = true
}

resource "aws_ssm_parameter" "ngw" {
  name  = "/${var.project}-${var.environment}-ngw"
  type  = "String"
  value = module.roboshop_vpc.nat_gateway_id
  overwrite = true
}