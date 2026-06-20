#IAM Instance Profile creation to attach admin access to bastion host
resource "aws_iam_instance_profile" "bastion_admin_profile" {
  name = "bastion-instance-profile"
  role = "bastion-admin-access"
}

#Bastion host creation
resource "aws_instance" "bastion" {
  ami           = data.aws_ami.roboshop_ami.id
  instance_type = "t3.micro"
  subnet_id     = local.public_subnet_id
  vpc_security_group_ids = [local.bastion_sg_id]
  user_data     = file("bootstrap.sh")
  iam_instance_profile = aws_iam_instance_profile.bastion_admin_profile.name
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
