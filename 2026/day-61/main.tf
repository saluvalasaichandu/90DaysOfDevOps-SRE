terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "terraweek-saichandu-2026"
}
resource "aws_instance" "my_ec2" {
  ami           = "ami-0b6d9d3d33ba97d99"
  instance_type = "t2.micro"

  tags = {
    Name = "TerraWeek-Day1"
  }
}