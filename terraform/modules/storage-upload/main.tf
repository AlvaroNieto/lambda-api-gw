# Content-Type list
locals {
  content_types = {
    css  = "text/css"
    html = "text/html"
    js   = "application/javascript"
    json = "application/json"
    txt  = "text/plain"
    png  = "image/png"
    jpg  = "image/jpeg"
  }
}

# Upload folders and subfolders to the S3 bucket
resource "aws_s3_object" "folder_files" {
  for_each = fileset("${var.html_path}", "**")

  #bucket = aws_s3_bucket.s3_staticsite.id
  bucket = var.upload_bucket_id
  key    = each.value
  source = "${var.html_path}${each.value}" 

  etag = filemd5("${var.html_path}${each.value}")

  # Set Content-Type based on the local.content_type
  content_type = lookup(local.content_types, split(".", each.value)[1], "text/html")
}

resource "aws_s3_object" "apifile" {
  bucket = var.upload_bucket_id
  key    = var.script_js_name
  content = var.script_jscontent
  content_type = "application/javascript"
}

