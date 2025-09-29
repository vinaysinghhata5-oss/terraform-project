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
    key          = "terraform.tfstate"
    region       = "ap-south-1"
    use_lockfile = true
    encrypt      = true
  }


}

provider "aws" {
  region = var.aws_region
}

