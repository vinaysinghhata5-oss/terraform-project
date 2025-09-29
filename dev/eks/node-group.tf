resource "aws_eks_node_group" "dev-group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "${var.project_name}-dev-group"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = module.vpc.private_subnets
  instance_types  = ["t3.medium"]

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  ami_type      = "AL2_x86_64"
  disk_size     = 20
  capacity_type = "ON_DEMAND"
  version       = var.eks_version

  tags = {
    Name = "${var.project_name}-dev-group"
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks_AmazonEC2ContainerRegistryReadOnly
  ]
}

#create iam role for node group
resource "aws_iam_role" "eks_node_role" {
  name = "${var.project_name}-eks-node-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "eks_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_role.name
}
resource "aws_iam_role_policy_attachment" "eks_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_role.name
}
resource "aws_iam_role_policy_attachment" "eks_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_role.name
}

