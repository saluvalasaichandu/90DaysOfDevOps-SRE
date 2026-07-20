terraform {
    required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.53"
    }
  }
  backend "s3" {
    bucket         = "terraweek-state-saichandu"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraweek-state-lock"
    encrypt        = true
  }
}