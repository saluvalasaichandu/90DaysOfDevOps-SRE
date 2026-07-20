module "compute" {
  source = "../compute"
  ami_id = "ami-0b6d9d3d33ba97d99"
  i_type = "t2.micro"
}

module "sg" {
  source  = "../sg"
  sg_name = "my-sg"
  ports   = [22, 80, 3306, 8080, 8081, 9000, 9090]
}

module "storage" {
  source      = "../storage"
  bucket_name = "my-terraform-bucket-2026-july-10th"
}