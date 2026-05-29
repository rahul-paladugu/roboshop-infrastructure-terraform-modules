variable "cidr_block" {
  default = "10.10.0.0/16"
}

variable "project" {
  default = "roboshop"
}

variable "environment" {
  default = "prod"
}

variable "public_subnet_cidrs" {
  default = ["10.10.1.0/24", "10.10.2.0/24"]
}

variable "private_subnet_cidrs" {
  default = ["10.10.11.0/24", "10.10.12.0/24"]
}

variable "database_subnet_cidrs" {
  default = ["10.10.21.0/24", "10.10.22.0/24"]
}

variable "az_names" {
  default = ["us-east-1a", "us-east-1b"]
}

variable "internet_cidr" {
  default = "0.0.0.0/0"
}