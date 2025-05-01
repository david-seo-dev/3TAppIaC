terraform {
  backend "s3" {
    bucket         = "my-tfstate-backend-yq1fve92"
    key            = "applayer/db/rds.tfstate"
    region         = "ap-southeast-2"
    dynamodb_table = "arn:aws:dynamodb:ap-southeast-2:905418153397:table/my-terraform-lock-table"
    encrypt        = true
  }
}

# output from bootstrap code
# dynamodb_table_arn = "arn:aws:dynamodb:ap-southeast-2:905418153397:table/my-terraform-lock-table"
# dynamodb_table_name = "my-terraform-lock-table"
# s3_bucket_arn = "arn:aws:s3:::my-tfstate-backend-yq1fve92"
# s3_bucket_name = "my-tfstate-backend-yq1fve92"
