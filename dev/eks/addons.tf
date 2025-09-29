#create addons for cluster
resource "aws_eks_addon" "vpc_cni" {
  addon_name       = "vpc-cni"
  cluster_name     = aws_eks_cluster.eks_cluster.name
  addon_version    = "v1.19.0-eksbuild.1"
    resolve_conflicts = "OVERWRITE"
    service_account_role_arn = aws_iam_role.eks_addon_role.arn 
    depends_on = [aws_eks_cluster.eks_cluster]
}

resource "aws_iam_role" "eks_addon_role" {
  name = "${var.project_name}-eks-addon-role"
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
resource "aws_iam_role_policy_attachment" "eks_AmazonEKS_CNI_Policy_addon" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_addon_role.name
}
resource "aws_eks_addon" "kube_proxy" {
  addon_name       = "kube-proxy"
  cluster_name     = aws_eks_cluster.eks_cluster.name
  addon_version    = "v1.19.0-eksbuild.1"
    resolve_conflicts = "OVERWRITE"
    service_account_role_arn = aws_iam_role.eks_addon_role.arn
    depends_on = [aws_eks_cluster.eks_cluster]
}
resource "aws_eks_addon" "core_dns" {
  addon_name       = "coredns"
  cluster_name     = aws_eks_cluster.eks_cluster.name
  addon_version    = "v1.8.0-eksbuild.1"
    resolve_conflicts = "OVERWRITE"
    service_account_role_arn = aws_iam_role.eks_addon_role.arn
    depends_on = [aws_eks_cluster.eks_cluster]
}

resource "aws_eks_addon" "aws_ebs_csi_driver" {
  addon_name       = "aws-ebs-csi-driver"
  cluster_name     = aws_eks_cluster.eks_cluster.name
  addon_version    = "v1.4.0-eksbuild.1"
    resolve_conflicts = "OVERWRITE"
    service_account_role_arn = aws_iam_role.eks_addon_role.arn 
    depends_on = [aws_eks_cluster.eks_cluster]
}

