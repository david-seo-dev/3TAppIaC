
data "aws_iam_policy_document" "ec2_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ec2_ssm_role" {
  name = "Demo-EC2-Role"
  description        = "IAM role for EC2 instances to allow SSM management"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role_policy.json

  tags = var.tags
}

# Attach the AWS Managed Policy for SSM Core functionality - replacement for AmazonEC2RoleforSSM
resource "aws_iam_role_policy_attachment" "ssm_managed_instance_core_attach" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_ssm_instance_profile" {
  name = "Demo-EC2-Instance-Profile"
  role = aws_iam_role.ec2_ssm_role.name
  tags = var.tags
}
