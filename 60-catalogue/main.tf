#Catalogue server creation
module "catalogue_server" {
  source = "git::https://github.com/rahul-paladugu/Terraform-modules-aws-ec2.git"
  components = ["catalogue"]
  ami_id = local.ami_id
  sg_ids = [local.catalogue_sg_id]
  instance_type = var.instance_type
  subnet_id = local.private_subnet_id
  common_tags = local.common_tags
  project = var.project
  environment = var.environment
}
# Wait for instance status checks to pass
resource "null_resource" "wait_for_catalogue" {
  depends_on = [module.catalogue_server]

  provisioner "local-exec" {
    command = "aws ec2 wait instance-status-ok --instance-ids ${module.catalogue_server.instance_id[0]}"
  }
}
#Configure mongodb
resource "terraform_data" "catalogue_setup" {
  triggers_replace = [module.catalogue_server.instance_id[0]]
  connection {
    host = module.catalogue_server.private_ip[0]
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
               "sh /tmp/bootstrap.sh catalogue ${var.environment} ${var.project}" ]
  }
}

#Create R53 record for Mysql
resource "aws_route53_record" "mysql_r53" {
  zone_id = local.zone_id
  name    = "catalogue-${var.project}-${var.environment}.${local.r53_common_name}"
  type    = "A"
  ttl     = 300
  records = [module.mysql_server.private_ip[0]]
}
