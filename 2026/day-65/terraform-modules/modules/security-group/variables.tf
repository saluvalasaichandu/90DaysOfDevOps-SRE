variable "vpc_id" {
  type        = string
  description = "VPC ID where the security group will be created"
}

variable "sg_name" {
  type        = string
  description = "Name of the security group"
}

variable "ingress_ports" {
  type        = list(number)
  description = "List of TCP ports to allow inbound"
  default     = [22, 80]
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the security group"
  default     = {}
}
