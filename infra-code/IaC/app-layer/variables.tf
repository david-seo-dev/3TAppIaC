# terraform-app-layer/variables.tf

variable "aws_region" {
  description = "AWS region where the resources will be created."
  type        = string
  default     = "ap-southeast-2"
}

variable "bucket_name_prefix" {
  description = "Prefix for the S3 bucket name. A random suffix will be added."
  type        = string
  default     = "app-layer-storage"
}

variable "enable_versioning" {
  description = "Set to true to enable versioning on the bucket."
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
  default = {
    ManagedBy = "Terraform"
    Project   = "my test app"
    Environment = "test"
  }
}

# --- NEW EC2 Variables ---

variable "app_subnet_id" {
  description = "The ID of the private subnet where the app EC2 instance should be launched."
  type        = string
}

variable "app_security_group_id" {
  description = "The ID of the security group to associate with the app EC2 instance."
  type        = string
}

variable "ec2_instance_type" {
  description = "Instance type for the EC2 instance (Free Tier eligible)."
  type        = string
  default     = "t3.micro" # Free Tier eligible
}

variable "ec2_instance_name_tag" {
  description = "Value for the Name tag of the EC2 instance."
  type        = string
  default     = "myapp-app-instance-1"
}

# --- End EC2 Variables ---
