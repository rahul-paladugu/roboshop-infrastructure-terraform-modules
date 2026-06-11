resource "aws_instance" "bastion" {
  ami           = data.aws_ami.roboshop_ami.id
  instance_type = "t3.micro"
  subnet_id     = local.public_subnet_id
  vpc_security_group_ids = [data.aws_ssm_parameter.sg_id.value]
  user_data     = file("bastion.sh")

  root_block_device {
    volume_size = 50
    volume_type = "gp3"
  }

  tags = {
    Name      = "bastion-${var.environment}-${var.project}"
    Terraform = "True"
    Project   = var.project
  }
}