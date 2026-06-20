#Frontend ALB Creation
resource "aws_lb" "frontend_alb" {
  name               = "frontend-alb-${local.common_name}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [local.frontend_alb_sg_id]
  subnets            = local.public_subnet_ids
  enable_deletion_protection = false
  tags = local.common_tags
}

#Frontend ALB LISTENING ON PORT 80
resource "aws_lb_listener" "frontend_alb" {
  load_balancer_arn = aws_lb.frontend_alb.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn = local.certificate_arn
  default_action {
    type = "fixed-response"

    fixed_response {
      status_code  = "404"
      content_type = "text/plain"
      message_body = "Not Found"
    }
  }
}

#Create R53 record for Frontend ALB
resource "aws_route53_record" "frontend_alb_r53" {
  zone_id = local.zone_id
  name    = "roboshop-${var.environment}.${local.r53_common_name}"
  type    = "A"
  allow_overwrite = true
    alias {
    name                   = aws_lb.frontend_alb.dns_name
    zone_id                = aws_lb.frontend_alb.zone_id
    evaluate_target_health = true
  }
}