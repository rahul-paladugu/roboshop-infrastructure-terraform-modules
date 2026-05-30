#Frontend accepting traffic from frontend-lb
resource "aws_vpc_security_group_ingress_rule" "frontend" {
  security_group_id = local.frontend_sg_id
  referenced_security_group_id = local.frontend_alb_sg_id
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}
#bastion accepting ssh access from public
resource "aws_vpc_security_group_ingress_rule" "bastion_accepting_public" {
  security_group_id = local.bastion_sg_id
  cidr_ipv4         = "0.0.0.0/0"
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}
#mongodb accepting traffic from bastion
resource "aws_vpc_security_group_ingress_rule" "mongodb_accepting_bastion" {
  security_group_id = local.mongodb_sg_id
  referenced_security_group_id = local.bastion_sg_id
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}
#redis accepting traffic from bastion
resource "aws_vpc_security_group_ingress_rule" "redis_accepting_bastion" {
  security_group_id = local.redis_sg_id
  referenced_security_group_id = local.bastion_sg_id
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}

#rabbitmq accepting traffic from bastion
resource "aws_vpc_security_group_ingress_rule" "rabbitmq_accepting_bastion" {
  security_group_id = local.rabbitmq_sg_id
  referenced_security_group_id = local.bastion_sg_id
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}