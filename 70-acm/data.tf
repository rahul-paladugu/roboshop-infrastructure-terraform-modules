data "aws_route53_zone" "roboshop_r53" {
  name         = "rscloudservices.icu"
  private_zone = false
}