resource "aws_s3_bucket" "mybucket" {
    bucket = "myterraform-bucket-08-072026"
}
resource "aws_s3_bucket_versioning" "mybucket_versioning"{
    bucket = aws_s3_bucket.mybucket.id
    versioning_configuration {
        status = "Enabled"
    }
}