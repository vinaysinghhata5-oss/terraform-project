terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  backend "s3" {
    bucket       = "my-terraform-state-bucket-dev-1"
    key          = "eks/terraform.tfstate"
    region       = "ap-south-1"
    use_lockfile = true
    encrypt      = true
  }
}

provider "aws" {
  region = var.aws_region
}

# Note: Ensure that the AWS provider is configured with the appropriate region and credentials.
# The backend configuration specifies that the Terraform state will be stored in an S3 bucket.
# Make sure that the S3 bucket exists and that the necessary permissions are in place for Terraform         
# to read and write the state file.
# Adjust the bucket name, key, and region as per your requirements.
# Always validate and plan your Terraform configurations before applying them to avoid any unintended changes.      
# This configuration is essential for setting up a reliable and consistent environment for managing your infrastructure with Terraform.