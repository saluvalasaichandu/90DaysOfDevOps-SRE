variable "vpc_id" {
  type        = string
  description = "VPC ID where the security group will be created"
}

variable "ingress_ports" {
  type        = list(number)
  description = "List of TCP ports to allow inbound"
  default     = [22, 80]
}

variable "environment" {
  type        = string
  description = "Deployment environment name"
}

variable "project_name" {
  type        = string
  description = "Project name for tagging and naming"
}