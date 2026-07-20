resource "aws_security_group" "mysg" {
  name = var.sg_name
  description = "Terraform SG"
  dynamic "ingress" {
    for_each = var.ports
    content {
      from_port = ingress.value
      to_port   = ingress.value
      protocol  = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks=["0.0.0.0/0"]
  }

}