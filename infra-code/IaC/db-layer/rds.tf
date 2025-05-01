# Generate password and storing it in secrets manager

# Resource to generate a random password
resource "random_password" "db_master_password" {
  length           = 16
  special          = true
  override_special = "_%@" #limiting based on documentation for limts of password chars
}

# Resource to create the secret container in Secrets Manager
resource "aws_secretsmanager_secret" "db_credentials" {
  name        = var.db_secret_name
  description = "Master user credentials for the application RDS database"
  tags        = var.tags
}

# Resource to store the actual username/password JSON in the secret
resource "aws_secretsmanager_secret_version" "db_credentials_version" {
  secret_id     = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    username = var.db_master_username
    password = random_password.db_master_password.result
  })
}

# RDS Subnet group attached to the SGs I have.

resource "aws_db_subnet_group" "db_subnet_group" {
  name        = var.db_subnet_group_name
  description = "DB Subnet group for the application RDS instance"
  subnet_ids  = var.db_subnet_ids # This is the private db subnets I created
  tags        = var.tags
}

# --- RDS DB Instance ---
# Making sure all of this is FREE TIER!!

resource "aws_db_instance" "app_db" {
  identifier             = var.db_instance_identifier
  instance_class         = var.db_instance_class      # Free Tier: db.t3.micro or db.t2.micro
  allocated_storage      = var.db_allocated_storage   # Free Tier: 20 GB
  storage_type           = var.db_storage_type        # gp3 recommended
  engine                 = "mysql"
  engine_version         = var.db_engine_version      # 8.0.35 requested
  #name                   = var.db_name                # Initial DB name: "database_1"
  username               = jsondecode(aws_secretsmanager_secret_version.db_credentials_version.secret_string).username
  password               = jsondecode(aws_secretsmanager_secret_version.db_credentials_version.secret_string).password
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = var.db_security_group_ids # Provided via tfvars (use your DB SG ID)

  # Free Tier / Cost Settings
  multi_az               = var.db_multi_az             # Free Tier: false
  publicly_accessible    = var.db_publicly_accessible  # Security: false
  storage_encrypted      = true                        # Security: true (usually no extra cost)
  backup_retention_period= var.db_backup_retention_period # Free Tier: 7 days allowed
  skip_final_snapshot    = var.db_skip_final_snapshot  # Set to false for production

  # Ensure secret exists before creating DB that uses it
  depends_on = [
    aws_secretsmanager_secret_version.db_credentials_version,
    aws_db_subnet_group.db_subnet_group
  ]

  tags = var.tags # Use var.tags or local.all_tags if defined
}
