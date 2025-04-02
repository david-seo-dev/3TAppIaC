# Use a random suffix to help ensure bucket name uniqueness
resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

# S3 Bucket for Terraform State
resource "aws_s3_bucket" "terraform_state" {
  # Bucket names must be globally unique
  bucket = "${var.bucket_name_prefix}-${random_string.bucket_suffix.result}"
  tags   = var.tags

  # Prevent accidental deletion of the state bucket
  lifecycle {
    prevent_destroy = true
  }
}

# Enable Versioning on the S3 Bucket
resource "aws_s3_bucket_versioning" "terraform_state_versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable Server-Side Encryption (SSE-S3)
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_sse" {
  bucket = aws_s3_bucket.terraform_state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256" # AWS managed keys (SSE-S3) - free
    }
  }
}

# Block all Public Access settings
resource "aws_s3_bucket_public_access_block" "terraform_state_public_access" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Optional: Lifecycle rule to manage noncurrent versions (cost optimization)
resource "aws_s3_bucket_lifecycle_configuration" "terraform_state_lifecycle" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    id     = "manage-noncurrent-versions"
    status = "Enabled"

    # Transition noncurrent versions to Infrequent Access after 30 days
    noncurrent_version_transition {
      noncurrent_days = 30
      storage_class   = "STANDARD_IA"
    }

    # Expire (delete) noncurrent versions after 365 days
    noncurrent_version_expiration {
      noncurrent_days = 365
    }

    # Expire incomplete multipart uploads after 7 days
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}


# DynamoDB Table for State Locking
resource "aws_dynamodb_table" "terraform_locks" {
  name         = var.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST" # Free tier friendly for low traffic
  hash_key     = "LockID"          # Required by Terraform

  attribute {
    name = "LockID"
    type = "S" # String
  }

  # Enable server-side encryption (AWS owned key by default, free)
  server_side_encryption {
    enabled = true
  }

  tags = var.tags

  # Prevent accidental deletion
  lifecycle {
    prevent_destroy = true
  }
}
