variable "aws_region" {
  description = "The AWS region to create resources in."
  type        = string
  default     = "us-east-1" # Choose your preferred region
}

variable "bucket_name_prefix" {
  description = "Prefix for the S3 bucket name. A random suffix will be added."
  type        = string
  default     = "my-tfstate-backend"
}

variable "dynamodb_table_name" {
  description = "Name for the DynamoDB table for state locking."
  type        = string
  default     = "my-terraform-lock-table"
}

variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
  default = {
    Terraform   = "true"
    Environment = "backend-infra"
    ManagedBy   = "Terraform"
  }
}
