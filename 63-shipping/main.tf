#Cart server creation
module "shipping_server" {
  source = "git::https://github.com/rahul-paladugu/Terraform-modules-aws-ec2.git"
  components = ["shipping"]
  ami_id = local.ami_id
  sg_ids = [local.shipping_sg_id]
  instance_type = var.instance_type
  subnet_id = local.private_subnet_id
  common_tags = local.common_tags
  project = var.project
  environment = var.environment
}

# Wait for instance status checks to pass
resource "time_sleep" "wait_for_shipping" {
  depends_on      = [module.shipping_server]
  create_duration = "60s"
}

#Configure Shipping
resource "terraform_data" "shipping_setup" {
  triggers_replace = [module.shipping_server.instance_id[0]]
  depends_on = [ time_sleep.wait_for_shipping ]
  connection {
    host = module.shipping_server.private_ip[0]
    user = local.remote_user
    password = local.remote_user_password
    type = "ssh"
  }
  #copy bootstarp into cart server
  provisioner "file" {
    source = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }
  #Execute bootstrap.sh
  provisioner "remote-exec" {
    inline = [ "chmod +x /tmp/bootstrap.sh",
               "sh /tmp/bootstrap.sh shipping ${var.environment} ${var.project}" ]
  }
}

#Stop the instance to take snapshot
resource "aws_ec2_instance_state" "shipping_stop" {
  instance_id = module.shipping_server.instance_id[0]
  state       = "stopped"
  depends_on = [ terraform_data.shipping_setup ]
}

#Generate AMI
resource "aws_ami_from_instance" "shipping" {
  name               = "ami-shipping-${var.environment}-${var.project}"
  source_instance_id = module.shipping_server.instance_id[0]
  depends_on = [ aws_ec2_instance_state.shipping_stop ]
}


#Create launch template using new AMI
resource "aws_launch_template" "shipping" {
  name = "template-shipping-${var.project}-${var.environment}"
  image_id = aws_ami_from_instance.shipping.id
  instance_initiated_shutdown_behavior = "terminate"
  instance_type = var.instance_type
  vpc_security_group_ids = [local.shipping_sg_id]
  update_default_version = true #When we run terraform apply again, new version will be created with new AMI
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "cart-${local.common_name}"
    }
  }
}

#Create target group
resource "aws_lb_target_group" "shipping" {
  name        = "tg-shipping-${var.environment}-${var.project}"
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
resource "aws_autoscaling_group" "shipping" {
  name = "asg-shipping-${var.environment}-${var.project}"
  desired_capacity   = 2
  max_size           = 10
  min_size           = 2
  vpc_zone_identifier = [local.private_subnet_id_1, local.private_subnet_id_2]
  target_group_arns = [aws_lb_target_group.shipping.arn]
  launch_template {
    id      = aws_launch_template.shipping.id
    version = aws_launch_template.shipping.latest_version
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

#Terminate the instance generated to configure golden AMI
resource "terraform_data" "shipping_instance" {
  triggers_replace = [module.shipping_server.instance_id[0]]
  depends_on = [ aws_autoscaling_group.shipping ]
  #Execute bootstrap.sh
  provisioner "local-exec" {
    command = "aws ec2 terminate-instances --instance-ids ${module.shipping_server.instance_id[0]}"
  }
}

resource "aws_autoscaling_policy" "shipping_cpu" {
  name                   = "shipping-cpu-70"
  autoscaling_group_name = aws_autoscaling_group.shipping.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 70.0
  }
}

resource "aws_lb_listener_rule" "shipping" {
  listener_arn = local.backend_alb_listener_arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.shipping.arn
  }

  condition {
    host_header {
      values = ["shipping.backend-alb-${var.environment}-${var.project}.${local.r53_common_name}"]
    }
  }
}