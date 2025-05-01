# terraform-app-layer/ec2.tf
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

# --- EC2 Instance Resource ---
resource "aws_instance" "app_instance" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = var.ec2_instance_type

  # Networking
  subnet_id                   = var.app_subnet_id
  vpc_security_group_ids      = [var.app_security_group_id]
  associate_public_ip_address = false

  iam_instance_profile = aws_iam_instance_profile.ec2_ssm_instance_profile.name

  tags = merge(var.tags, {
    Name = var.ec2_instance_name_tag
  })

  # Ensure IAM profile exists before creating instance
  depends_on = [
    aws_iam_instance_profile.ec2_ssm_instance_profile,
  ]
}
