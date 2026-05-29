resource "aws_instance" "mongodb" {
  ami           = data.aws_ami.roboshop_ami.id
  instance_type = "t3.micro"
  subnet_id = local.db_subnet_id
  vpc_security_group_ids = [local.mongodb_sg_id]

  tags = {
    Name = "mongodb-${var.environment}-${var.project}"
    Terraform = "True"
    Project = var.project
  }
}

resource "terraform_data" "mongodb_setup" {
  triggers_replace = [aws_instance.mongodb.id]
  connection {
    host = aws_instance.mongodb.private_ip
    user = local.remote_user
    password = local.remote_user_password
    type = "ssh"
  }
  #copy bootstarp into mongodb server
  provisioner "file" {
    source = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }
  #Execute bootstrap.sh
  provisioner "remote-exec" {
    inline = [ "chmod +x /tmp/bootstrap.sh",
               "sh /tmp/bootstrap.sh mongodb" ]
  }
}