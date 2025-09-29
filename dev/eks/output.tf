# EKS Outputs
# =========================
output "eks_cluster_name" {
  value = aws_eks_cluster.eks_cluster.name
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.eks_cluster.endpoint
}

output "eks_cluster_arn" {
  value = aws_eks_cluster.eks_cluster.arn
}

# =========================
# VPC Outputs
# =========================
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

# Optional outputs if you added them in the VPC module
output "nat_gateway_ids" {
  value = module.vpc.nat_gateway_ids
}

output "internet_gateway_ids" {
  value = module.vpc.internet_gateway_ids
}