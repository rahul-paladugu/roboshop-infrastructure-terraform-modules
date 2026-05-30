resource "aws_instance" "mongodb" {
  ami           = local.ami_id
  instance_type = var.instance_type
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

resource "aws_instance" "redis" {
  ami           = local.ami_id
  instance_type = var.instance_type
  subnet_id = local.db_subnet_id
  vpc_security_group_ids = [local.redis_sg_id]

  tags = {
    Name = "redis-${var.environment}-${var.project}"
    Terraform = "True"
    Project = var.project
  }
}

resource "terraform_data" "redis_setup" {
  triggers_replace = [aws_instance.redis.id]
  connection {
    host = aws_instance.redis.private_ip
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
               "sh /tmp/bootstrap.sh redis" ]
  }
}