#User server creation
module "user_server" {
  source = "git::https://github.com/rahul-paladugu/Terraform-modules-aws-ec2.git"
  components = ["user"]
  ami_id = local.ami_id
  sg_ids = [local.user_sg_id]
  instance_type = var.instance_type
  subnet_id = local.private_subnet_id
  common_tags = local.common_tags
  project = var.project
  environment = var.environment
}
# Wait for instance status checks to pass
resource "time_sleep" "wait_for_user" {
  depends_on      = [module.user_server]
  create_duration = "60s"
}

#Configure User
resource "terraform_data" "user_setup" {
  triggers_replace = [module.user_server.instance_id[0]]
  depends_on = [ time_sleep.wait_for_user ]
  connection {
    host = module.user_server.private_ip[0]
    user = local.remote_user
    password = local.remote_user_password
    type = "ssh"
  }
  #copy bootstarp into user server
  provisioner "file" {
    source = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }
  #Execute bootstrap.sh
  provisioner "remote-exec" {
    inline = [ "chmod +x /tmp/bootstrap.sh",
               "sh /tmp/bootstrap.sh user ${var.environment} ${var.project}" ]
  }
}

#Stop the instance
resource "aws_ec2_instance_state" "user_stop" {
  instance_id = module.user_server.instance_id[0]
  state       = "stopped"
  depends_on = [ terraform_data.user_setup ]
}

#Generate Golden AMI
resource "aws_ami_from_instance" "user" {
  name               = "user-${var.environment}-${var.project}-ami"
  source_instance_id = module.user_server.instance_id[0]
  depends_on = [ aws_ec2_instance_state.user_stop ]
}

#Terminate AMI after generation as it simply costs sitting stopped state
resource "aws_ec2_instance_state" "user_start" {
  instance_id = module.user_server.instance_id[0]
  state       = "running"
  depends_on  = [aws_ami_from_instance.user]
}

#Create launch template using new AMI
resource "aws_launch_template" "user" {
  name = "user-${var.project}-${var.environment}-template"
  lifecycle {
  create_before_destroy = true
  }
  image_id = aws_ami_from_instance.user.id
  instance_initiated_shutdown_behavior = "terminate"
  instance_type = var.instance_type
  vpc_security_group_ids = [local.user_sg_id]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "user-${local.common_name}"
    }
  }
}

#Create target group
resource "aws_lb_target_group" "user" {
  name        = "user-${var.environment}-${var.project}-tg"
  target_type = "instance"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = local.vpc_id
  health_check {
   path                = "/health"
   protocol            = "HTTP"
   healthy_threshold   = 2
   unhealthy_threshold = 2
   interval            = 30
   timeout             = 5
   matcher             = "200-299"
  }
}

#Create ASG
resource "aws_autoscaling_group" "user" {
  name = "-${var.environment}-${var.project}-asg"
  desired_capacity   = 3
  max_size           = 10
  min_size           = 3
  vpc_zone_identifier = [local.private_subnet_id_1, local.private_subnet_id_2]
  target_group_arns = [aws_lb_target_group.user.arn]
  launch_template {
    id      = aws_launch_template.user.id
    version = aws_launch_template.user.latest_version
  }
  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
  }
  dynamic "tag" {
   for_each =  local.asg_tags  
    content {
    key                 = tag.key
    value               = tag.value
    propagate_at_launch = true
   }
  }
}
resource "aws_autoscaling_policy" "user_cpu" {
  name                   = "user-cpu-70"
  autoscaling_group_name = aws_autoscaling_group.user.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 70.0
  }
}
