resource "aws_lb" "backend_alb" {
  name               = "backend-alb-${local.common_name}"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [local.backend_alb_sg_id]
  subnets            = local.public_subnet_ids
  enable_deletion_protection = false
  tags = local.common_tags
}

#BACKEND ALB LISTENING ON PORT 80
resource "aws_lb_listener" "backend_alb" {
  load_balancer_arn = aws_lb.backend_alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "hello this is backend alb"
      status_code = "200"
    }
  }
}

#Create R53 record for Backend ALB
resource "aws_route53_record" "backend_alb_r53" {
  zone_id = local.zone_id
  name    = "*.backend-alb.${var.project}-${var.environment}.${local.r53_common_name}"
  type    = "A"
  allow_overwrite = true
    alias {
    name                   = aws_lb.backend_alb.dns_name
    zone_id                = aws_lb.backend_alb.zone_id
    evaluate_target_health = true
  }
}