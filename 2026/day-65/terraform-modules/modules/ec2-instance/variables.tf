variable "ami_id" {
  type        = string
  description = "AMI ID to launch the EC2 instance with"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID where the instance will be placed"
}

variable "security_group_ids" {
  type        = list(string)
  description = "List of security group IDs to attach"
}

variable "instance_name" {
  type        = string
  description = "Value for the Name tag on the EC2 instance"
}

variable "tags" {
  type        = map(string)
  description = "Additional tags to apply to the instance"
  default     = {}
}
