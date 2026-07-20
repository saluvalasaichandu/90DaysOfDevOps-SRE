resource "aws_s3_bucket" "mybucket" {
    bucket= each.value
    for_each = toset(local.bucket_names)
}
locals{
    bucket_names= ["mybucket-ssc-2026-dev", "mybucket-ssc-2026-uat", "mybucket-ssc-2026-prod"]
}