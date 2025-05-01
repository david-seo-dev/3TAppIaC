# terraform-security-groups/main.tf

# Security Group 1: Web ALB (Example: Allow HTTP inbound)
resource "aws_security_group" "web_alb_sg" {
  name        = "${var.project_name}-${var.environment}-web-external-alb-sg"
  description = "Allow HTTP inbound traffic for web servers"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP from anywhere"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = local.all_tags
}

# Security Group 2: Web Servers (Example: Allow HTTP inbound)
resource "aws_security_group" "web_sg" {
  name        = "${var.project_name}-${var.environment}-web-sg"
  description = "Allow HTTP inbound traffic for web servers"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.web_alb_sg.id]
    description     = "Allow HTTP traffic from Web alb SG"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["192.168.0.0/22"] # My VPC cidr range
    description = "Allow HTTP from VPC internal range (192.168.0.0/22)"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = local.all_tags
}

# Security Group 3: App layer SG
resource "aws_security_group" "app_sg" {
  name        = "${var.project_name}-${var.environment}-app-sg"
  description = "Allow traffic from web servers for application logic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 4000 # this is for react default port
    to_port     = 4000
    protocol    = "tcp"
    cidr_blocks = ["192.168.0.0/22"]
    description = "Allow within my VPC"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = local.all_tags
}

# Security Group 4: Internal ALB for app (Example: Allow traffic from App SG)
resource "aws_security_group" "internal_alb_sg" {
  name        = "${var.project_name}-${var.environment}-internal-alb-sg"
  description = "Allow traffic for internal ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = ["192.168.0.0/22"] # cidr range of the VPC
    description     = "Allow MySQL traffic from App SG"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = local.all_tags
}

# Security Group 5: DB SG
resource "aws_security_group" "db_sg" {
  name        = "${var.project_name}-${var.environment}-db-sg"
  description = "SG for DB allowing traffic in from APP layer"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 3306 # Standard MySQL/Aurora port
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id]
    description     = "Allow MySQL/Aurora traffic from App SG"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = local.all_tags
}

# # Security Group 6: Bastion (Not properly set up yet but we want to add my ip)
# resource "aws_security_group" "bastion_sg" {
#   name        = "${var.project_name}-${var.environment}-bastion-sg"
#   description = "SG for remote bastion"
#   vpc_id      = var.vpc_id

#   # ingress {
#   #   from_port   = 22
#   #   to_port     = 22
#   #   protocol    = "tcp"
#   #   cidr_blocks = ["YOUR_HOME_OR_OFFICE_IP/32"] #This should be my ip - just added this for demonstration
#   #   description = "Allow SSH from specific IP"
#   # }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#     description = "Allow all outbound traffic"
#   }

#   tags = local.all_tags
# }
