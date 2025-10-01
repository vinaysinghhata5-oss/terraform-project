terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
  }
  http = {
    source  = "hashicorp/http"
    version = "~> 3.0"
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