terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Use a recent version
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
  # This bootstrap code itself should ideally use a local backend
  # or be manually applied initially.
  # Do NOT configure a remote backend here pointing to the resources
  # it's trying to create!
  backend "local" {}
}

provider "aws" {
  region = var.aws_region
}
