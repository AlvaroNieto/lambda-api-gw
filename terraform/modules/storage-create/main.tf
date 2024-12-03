resource "aws_s3_bucket" "s3_staticsite" {
  bucket = var.bucket_name
  tags = {
    Name        = "alvaronl.com website bucket"
    Environment = "Production"
  }
}

# Enable versioning on the S3 bucket
resource "aws_s3_bucket_versioning" "s3_staticsite_alvaronl_versioning" {
  bucket = aws_s3_bucket.s3_staticsite.bucket

  versioning_configuration {
    status = "Enabled"
  }
}

# Unblock Public Access settings for S3 bucket
resource "aws_s3_bucket_public_access_block" "s3_staticsite_public_access_allow" {
  bucket = aws_s3_bucket.s3_staticsite.id

  block_public_acls   = false
  block_public_policy = false
  ignore_public_acls  = false
  restrict_public_buckets = false
}

# Add a bucket policy for public read access to the objects
resource "aws_s3_bucket_policy" "s3_staticsite_public_acl" {
  bucket = aws_s3_bucket.s3_staticsite.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "PublicReadGetObject",
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.s3_staticsite.arn}/*"
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.s3_staticsite_public_access_allow]
}
