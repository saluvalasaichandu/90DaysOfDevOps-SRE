provider "aws" {
  region = var.region
}

data "aws_ami" "amazon_linux" {

  most_recent = true

  owners = ["amazon"]

  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*"]
  }
}

# Fetch Available Availability Zones
data "aws_availability_zones" "available" {}

# VPC
resource "aws_vpc" "my_vpc" {

  cidr_block = var.vpc_cidr

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# Public Subnet
resource "aws_subnet" "mysubnet" {

  vpc_id = aws_vpc.my_vpc.id

  cidr_block = var.subnet_cidr

  availability_zone = data.aws_availability_zones.available.names[0]

  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "myigw" {

  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

# Route Table
resource "aws_route_table" "myrt" {

  vpc_id = aws_vpc.my_vpc.id

  route {

    cidr_block = "0.0.0.0/0"

    gateway_id = aws_internet_gateway.myigw.id
  }

  tags = {
    Name = "${var.project_name}-rt"
  }
}

# Route Table Association
resource "aws_route_table_association" "myrta" {

  subnet_id = aws_subnet.mysubnet.id

  route_table_id = aws_route_table.myrt.id
}

# Security Group
resource "aws_security_group" "my_sg" {

  name = "${var.project_name}-sg"

  vpc_id = aws_vpc.my_vpc.id

  ingress {
    description = "SSH"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {

    from_port = 0

    to_port = 0

    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-sg"
  }
}

# EC2 Instance
resource "aws_instance" "my_ec2" {

  ami = "ami-0b6d9d3d33ba97d99"

  instance_type = var.environment == "prod" ? "t3.small" : var.instance_type

  subnet_id = aws_subnet.mysubnet.id

  vpc_security_group_ids = [aws_security_group.my_sg.id]

  tags = {
    Name = "${var.project_name}-ec2"
    Environment = var.environment
  }

  lifecycle {
    create_before_destroy = true
  }
}

# S3 Bucket
resource "aws_s3_bucket" "my_bucket" {

  bucket = "${var.project_name}-${var.environment}-bucket-2026"

  depends_on = [aws_instance.my_ec2]

  tags = {
    Name = "${var.project_name}-bucket"
    Environment = var.environment
  }
}