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

#Stop the instance
resource "aws_ec2_instance_state" "catalogue" {
  instance_id = module.catalogue_server.instance_id[0]
  state       = "stopped"
  depends_on = [ terraform_data.catalogue_setup ]
}

#Generate AMI
resource "aws_ami_from_instance" "catalogue" {
  name               = "${var.project}-catalogue-ami"
  source_instance_id = aws_ec2_instance_state.catalogue.instance_id
  depends_on = [ aws_ec2_instance_state.catalogue ]
}

#Create launch template using new AMI
resource "aws_launch_template" "catalogue" {
  name = "catalogue-${var.project}-${var.environment}"

  image_id = aws_ami_from_instance.catalogue.id
  instance_initiated_shutdown_behavior = "terminate"
  instance_type = var.instance_type
  placement {
    availability_zone = "us-east-1a"
  }
  vpc_security_group_ids = [local.catalogue_sg_id]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "catalogue-${local.common_name}"
    }
  }
}

#Create target group
resource "aws_lb_target_group" "catalogue" {
  name        = "catalogue-tg"
  target_type = "instance"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = local.vpc_id
}

#Create ASG
resource "aws_autoscaling_group" "catalogue" {
  desired_capacity   = 1
  max_size           = 10
  min_size           = 1
  vpc_zone_identifier = [local.private_subnet_id_1, local.private_subnet_id_2]
  target_group_arns = aws_lb_target_group.catalogue.arn
  launch_template {
    id      = aws_launch_template.catalogue.id
    version = aws_launch_template.catalogue.latest_version
  }

  dynamic "tag" {
  for_each =  local.asg_tags  
    content {
    key                 = each.key
    value               = each.Value
    propagate_at_launch = true
  }
  }
}
resource "aws_autoscaling_policy" "catalogue_cpu" {
  name                   = "catalogue-cpu-70"
  autoscaling_group_name = aws_autoscaling_group.catalogue.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 70.0
  }
}
