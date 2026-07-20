variable "cidr" {
  type        = string
  description = "VPC CIDR block"
}

variable "public_subnet_cidr" {
  type        = string
  description = "Public subnet CIDR block"
}

variable "environment" {
  type        = string
  description = "Deployment environment name"
}

variable "project_name" {
  type        = string
  description = "Project name for tagging and naming"
}