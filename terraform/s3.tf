resource "aws_s3_bucket" "hocr_data" {
  bucket = "hocr-data"
  acl    = "private"

  lifecycle {
    prevent_destroy = true
  }
}
