# terraform-security-groups/variables.tf

variable "aws_region" {
  description = "AWS region where the security groups will be created."
  type        = string
  default     = "ap-southeast-2"
}

variable "vpc_id" {
  description = "The ID of the VPC where the security groups should be created."
  type        = string
}

variable "project_name" {
  description = "A name prefix for the security groups."
  type        = string
  default     = "myapp"
}

variable "environment" {
  description = "Deployment environment (e.g., dev, staging, prod)."
  type        = string
  default     = "test"
}

variable "common_tags" {
  description = "Common tags to apply to all security groups."
  type        = map(string)
  default = {
    ManagedBy   = "Terraform"
    Project     = "myTestApp"
    Environment = "test"
  }

  validation {
    condition     = contains(keys(var.common_tags), "Environment")
    error_message = "The common_tags map must contain an 'Environment' key."
  }
}

locals {
  all_tags = merge(var.common_tags, {
    Environment = var.environment
  })
}
