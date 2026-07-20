variable "ami_id" {
  type        = string
  description = "AMI ID for the EC2 instance"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID to launch the instance in"
}

variable "security_group_ids" {
  type        = list(string)
  description = "List of security group IDs to attach"
}

variable "environment" {
  type        = string
  description = "Deployment environment name"
}

variable "project_name" {
  type        = string
  description = "Project name for tagging and naming"
}