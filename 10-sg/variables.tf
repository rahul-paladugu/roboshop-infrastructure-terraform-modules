variable "project" {
  default = "roboshop"
}

variable "environment" {
  default = "prod"
}

variable "components" {
  default = ["frontend","catalogue","user","cart","shipping","payment","mongodb","redis","mysql","rabbitmq","bastion","frontend-alb","backend-alb"]
}