
variable "aws_region" {
  description = "AWS region where the resources will be created."
  type        = string
  default     = "ap-southeast-2"
}

variable "bucket_name_prefix" {
  description = "Prefix for the S3 bucket name. A random suffix will be added."
  type        = string
  default     = "myapp-layer-storage"
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
    Project   = "MyAppLayer"
    Environment = "shared"
  }
}

variable "vpc_id" {
  description = "The ID of the VPC where the RDS instance and subnet group will be created."
  type        = string
  # No default - MUST be provided in tfvars
}

variable "db_subnet_ids" {
  description = "A list of subnet IDs for the DB Subnet Group."
  type        = list(string)
  # No default - MUST be provided in tfvars
}

variable "db_security_group_ids" {
  description = "A list of security group IDs to associate with the RDS instance."
  type        = list(string)
  # No default - MUST be provided in tfvars (Use the ID of the 'db_sg' created previously)
}

variable "db_subnet_group_name" {
  description = "Name for the RDS DB Subnet Group."
  type        = string
  default     = "db-sngp" # As requested
}

variable "db_instance_identifier" {
  description = "Unique identifier for the RDS DB instance."
  type        = string
  default     = "myapp-db-instance" # Example identifier
}

variable "db_name" {
  description = "The name of the initial database created in the RDS instance."
  type        = string
  default     = "database_1"
}

variable "db_instance_class" {
  description = "Instance class for the RDS DB instance (Free Tier eligible)."
  type        = string
  default     = "db.t4g.micro"
}

variable "db_allocated_storage" {
  description = "Allocated storage in GB for the RDS instance (Free Tier limit)."
  type        = number
  default     = 20
}

variable "db_storage_type" {
  description = "Storage type for the RDS instance."
  type        = string
  default     = "gp2" # General Purpose SSD (gp3 often better value than gp2)
}

variable "db_engine_version" {
  description = "MySQL engine version for the RDS instance."
  type        = string
  default     = "8.0.35" # As requested
}

variable "db_master_username" {
  description = "Master username for the RDS instance."
  type        = string
  default     = "admin"
}

variable "db_secret_name" {
  description = "Name for the secret in AWS Secrets Manager to store DB credentials."
  type        = string
  default     = "myapp/db/master-credentials"
}

variable "db_backup_retention_period" {
  description = "Days to retain automated backups (Free Tier allows up to 7)."
  type        = number
  default     = 7
}

variable "db_skip_final_snapshot" {
  description = "Set to true to skip final snapshot on deletion (use false for production)."
  type        = bool
  default     = true
}

variable "db_multi_az" {
  description = "Specifies if the DB instance is multi-AZ (Free Tier is single-AZ)."
  type        = bool
  default     = false # Must be false for Free Tier!!!
}

variable "db_publicly_accessible" {
  description = "Specifies if the DB instance is publicly accessible."
  type        = bool
  default     = false
}
