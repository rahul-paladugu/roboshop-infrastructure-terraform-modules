#Mongodb server creation
module "mongodb_server" {
  source = "git::https://github.com/rahul-paladugu/Terraform-modules-aws-ec2.git"
  components = [mongodb]
  ami_id = local.ami_id
  sg_id = local.mongodb_sg_id
  common_tags = var.common_tags
  project = var.project
  environment = var.environment
}
# Wait for instance status checks to pass
resource "null_resource" "wait_for_mongodb" {
  depends_on = [aws_instance.redis]

  provisioner "local-exec" {
    command = "aws ec2 wait instance-status-ok --instance-ids ${aws_instance.mongodb.id}"
  }
}
#Configure mongodb
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
#Redis server creation
module "redis_server" {
  source = "git::https://github.com/rahul-paladugu/Terraform-modules-aws-ec2.git"
  components = [redis]
  ami_id = local.ami_id
  sg_id = local.redis_sg_id
  common_tags = var.common_tags
  project = var.project
  environment = var.environment
}
# Wait for instance status checks to pass
resource "null_resource" "wait_for_redis" {
  depends_on = [aws_instance.redis]

  provisioner "local-exec" {
    command = "aws ec2 wait instance-status-ok --instance-ids ${aws_instance.redis.id}"
  }
}
#Configure redis
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

#Rabbitmq server creation
module "rabbitmq_server" {
  source = "git::https://github.com/rahul-paladugu/Terraform-modules-aws-ec2.git"
  components = [rabbitmq]
  ami_id = local.ami_id
  sg_id = local.rabbitmq_sg_id
  common_tags = var.common_tags
  project = var.project
  environment = var.environment
}
# Wait for instance status checks to pass
resource "null_resource" "wait_for_rabbitmq" {
  depends_on = [aws_instance.rabbitmq]

  provisioner "local-exec" {
    command = "aws ec2 wait instance-status-ok --instance-ids ${aws_instance.rabbitmq.id}"
  }
}
#Configure rabbitmq
resource "terraform_data" "rabbitmq_setup" {
  triggers_replace = [aws_instance.rabbitmq.id]
  connection {
    host = aws_instance.redis.private_ip
    user = local.remote_user
    password = local.remote_user_password
    type = "ssh"
  }
  
  #copy bootstarp into rabbitmq server
  provisioner "file" {
    source = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }
  #Execute bootstrap.sh
  provisioner "remote-exec" {
    inline = [ "chmod +x /tmp/bootstrap.sh",
               "sh /tmp/bootstrap.sh rabbitmq" ]
  }
}