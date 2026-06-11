#Bastion accepting ssh access from public
resource "aws_vpc_security_group_ingress_rule" "bastion_accepting_public" {
  security_group_id = local.bastion_sg_id
  cidr_ipv4         = "0.0.0.0/0"
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}
#Mongodb accepting traffic from bastion
resource "aws_vpc_security_group_ingress_rule" "mongodb_accepting_bastion" {
  security_group_id = local.mongodb_sg_id
  referenced_security_group_id = local.bastion_sg_id
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}
#Redis accepting traffic from bastion
resource "aws_vpc_security_group_ingress_rule" "redis_accepting_bastion" {
  security_group_id = local.redis_sg_id
  referenced_security_group_id = local.bastion_sg_id
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}

#Rabbitmq accepting traffic from bastion
resource "aws_vpc_security_group_ingress_rule" "rabbitmq_accepting_bastion" {
  security_group_id = local.rabbitmq_sg_id
  referenced_security_group_id = local.bastion_sg_id
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}

#Mysql accepting traffic from bastion
resource "aws_vpc_security_group_ingress_rule" "mysql_accepting_bastion" {
  security_group_id = local.mysql_sg_id
  referenced_security_group_id = local.bastion_sg_id
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}

#Catalogue accepting traffic from bastion
resource "aws_vpc_security_group_ingress_rule" "catalogue_accepting_bastion" {
  security_group_id = local.catalogue_sg_id
  referenced_security_group_id = local.bastion_sg_id
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}