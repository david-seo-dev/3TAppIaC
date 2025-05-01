# terraform-app-layer/outputs.tf

output "s3_bucket_name" {
  description = "The globally unique name of the app layer S3 storage bucket."
  value       = aws_s3_bucket.app_layer_storage.id
}

output "s3_bucket_arn" {
  description = "The ARN (Amazon Resource Name) of the app layer S3 storage bucket."
  value       = aws_s3_bucket.app_layer_storage.arn
}

output "s3_bucket_region" {
  description = "The AWS region where the app layer S3 bucket was created."
  value       = aws_s3_bucket.app_layer_storage.region
}

output "ec2_instance_profile_name" {
  description = "The name of the IAM instance profile for EC2 SSM access."
  value       = aws_iam_instance_profile.ec2_ssm_instance_profile.name
}