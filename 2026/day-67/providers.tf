provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket       = "capstone-sai-bucket-2026"
    key          = "capstone/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}

