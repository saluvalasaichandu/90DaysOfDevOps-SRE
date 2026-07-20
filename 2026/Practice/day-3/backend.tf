terraform{
    backend "s3"{
        bucket= "myterraform-bucket-08-072026"
        key= "prod/terraform.tfstate"
        region = "us-east-1"
        use_lockfile = true
    }
}