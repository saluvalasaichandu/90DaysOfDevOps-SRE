variable "project_name" {
  type    = string
  default = "terraweek"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block for this environment"
}

variable "subnet_cidr" {
  type        = string
  description = "Public subnet CIDR block for this environment"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type for this environment"
}

variable "ingress_ports" {
  type        = list(number)
  description = "Ports to allow inbound"
  default     = [22, 80]
}