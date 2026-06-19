terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
    backend "s3" {
    bucket         = "roboshop-terraform-modules"
    key            = "roboshop-frontend-alb-state-file-prod"
    region         = "us-east-1"
    encrypt        = true
    use_lockfile = true
  }
}