# terraform-app-layer/terraform.tfvars.example

# for all variables I love to change from hard coded but would like to data block or some sort of local

vpc_id = "vpc-0a79a071f51111173"

db_subnet_ids = [
  "subnet-05122c88a0bec4eda",
  "subnet-0d8c9aecdb731a058"
]

db_security_group_ids = ["sg-0e883c8ebbfb79bf5"]

# --- variables - all default are set to free-tier - found this on the internet - useful!

# aws_region               = "ap-southeast-2"
# db_instance_identifier   = "myapp-db-instance"
# db_name                  = "database_1"
# db_instance_class        = "db.t3.micro"
# db_allocated_storage     = 20
# db_storage_type          = "gp3"
# db_engine_version        = "8.0.35"
# db_master_username       = "admin"
# db_secret_name           = "myapp/db/master-credentials"
# db_backup_retention_period = 7
# db_skip_final_snapshot   = true
# db_multi_az              = false
# db_publicly_accessible = false
# db_subnet_group_name     = "db-sngp"

# tags = {
#   ManagedBy = "Terraform"
#   Project   = "MyAppLayer"
#   Environment = "dev" # Example: Override default environment tag
# }
