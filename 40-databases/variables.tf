variable "project" {
  default = "roboshop"
}

variable "environment" {
  default = "prod"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "common_tags" {
  default = {
    Terraform = "True"
    Project = "Roboshop"
  }
}