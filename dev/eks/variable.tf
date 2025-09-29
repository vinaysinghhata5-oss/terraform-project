variable "aws_region" {
  type        = string
  default     = "ap-south-1"
  description = "The AWS region to deploy resources in "
}

variable "project_name" {
  type        = string
  default     = "dev-eks"
  description = "The name of the project"
}


variable "eks_version" {
  type        = string
  default     = "1.31"
  description = "The version of EKS to deploy"
}   