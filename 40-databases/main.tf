#Mongodb server creation
module "mongodb_server" {
  source = "git::https://github.com/rahul-paladugu/Terraform-modules-aws-ec2.git"
  components = ["mongodb"]
  ami_id = local.ami_id
  sg_ids = [local.mongodb_sg_id]
  instance_type = var.instance_type
  common_tags = var.common_tags
  project = var.project
  environment = var.environment
}
# Wait for instance status checks to pass
resource "null_resource" "wait_for_mongodb" {
  depends_on = [module.mongodb_server]

  provisioner "local-exec" {
    command = "aws ec2 wait instance-status-ok --instance-ids ${module.mongodb_server.id}"
  }
}
#Configure mongodb
resource "terraform_data" "mongodb_setup" {
  triggers_replace = [module.mongodb_server.id]
  connection {
    host = module.mongodb_server.private_ip
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
  components = ["redis"]
  ami_id = local.ami_id
  sg_ids = [local.redis_sg_id]
  instance_type = var.instance_type
  common_tags = var.common_tags
  project = var.project
  environment = var.environment
}
# Wait for instance status checks to pass
resource "null_resource" "wait_for_redis" {
  depends_on = [module.redis_server]

  provisioner "local-exec" {
    command = "aws ec2 wait instance-status-ok --instance-ids ${module.redis_server.id}"
  }
}
#Configure redis
resource "terraform_data" "redis_setup" {
  triggers_replace = [module.redis_server.id]
  connection {
    host = module.redis_server.private_ip
    user = local.remote_user
    password = local.remote_user_password
    type = "ssh"
  }
  
  #Copy bootstarp into redis server
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
  components = ["rabbitmq"]
  ami_id = local.ami_id
  sg_ids = [local.rabbitmq_sg_id]
  instance_type = var.instance_type
  common_tags = var.common_tags
  project = var.project
  environment = var.environment
}
# Wait for instance status checks to pass
resource "null_resource" "wait_for_rabbitmq" {
  depends_on = [module.rabbitmq_server]

  provisioner "local-exec" {
    command = "aws ec2 wait instance-status-ok --instance-ids ${module.rabbitmq_server.id}"
  }
}
#Configure rabbitmq
resource "terraform_data" "rabbitmq_setup" {
  triggers_replace = [module.rabbitmq_server.id]
  connection {
    host = module.rabbitmq_server.private_ip
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