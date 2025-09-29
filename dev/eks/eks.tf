module "vpc" {
  source               = "../vpc"
  project_name         = var.project_name
  aws_region           = var.aws_region
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
  availability_zones   = ["ap-south-1a", "ap-south-1b"]
}

# =========================
# EKS IAM Role
# =========================
resource "aws_iam_role" "eks_role" {
  name = "${var.project_name}-eks-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_role.name
}

resource "aws_iam_role_policy_attachment" "eks_AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_role.name
}


resource "aws_eks_cluster" "eks_cluster" {
  name     = var.project_name
  version  = var.eks_version
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids = module.vpc.private_subnets
    # Optional: enable public access if needed
    endpoint_public_access = true
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks_AmazonEKSServicePolicy
  ]
}

