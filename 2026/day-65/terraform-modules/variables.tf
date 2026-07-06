variable "region" {
  type    = string
  default = "us-east-1"
}

variable "project_name" {
  type        = string
  description = "Project name -- required, no default"
}

variable "environment" {
  type    = string
  default = "dev"
}
