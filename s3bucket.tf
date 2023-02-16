resource "aws_s3_bucket" "cw_s3" {
  bucket = "cloudwatch1_s3"
  acl    = "private"

  tags = {
    Name        = "My_bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_versioning" "cw_s3" {
  bucket = aws_s3_bucket.cw_s3.id
  versioning_configuration {
    status = "Enabled"
  }
}