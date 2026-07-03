variable "region" {
  default = "us-east-1"
}

variable "project_name" {}

variable "environment" {
  default = "dev"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "allowed_ports" {
  default = [22,80,443]
}

variable "extra_tags" {
  default = {}
}