resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

# S3 Bucket Resource (Name will now use the new prefix)
resource "aws_s3_bucket" "app_layer_storage" {
  bucket = "${var.bucket_name_prefix}-${random_string.bucket_suffix.result}"
  tags   = var.tags
}

# Block all Public Access settings
resource "aws_s3_bucket_public_access_block" "app_layer_storage_public_access" {
  bucket = aws_s3_bucket.app_layer_storage.id
}

resource "aws_s3_bucket_lifecycle_configuration" "app_layer_storage_lifecycle" {
  bucket = aws_s3_bucket.app_layer_storage.id
  rule {
    id     = "abort-incomplete-uploads"
    status = "Enabled"

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}
