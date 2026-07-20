provider "aws" {
    region ="us-east-1"
}
resource "aws_instance" "myec2"{
    ami =var.ami_id
    instance_type =var.i_type
}