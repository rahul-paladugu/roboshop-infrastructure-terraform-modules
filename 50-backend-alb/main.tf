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