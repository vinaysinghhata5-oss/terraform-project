# AWS Load Balancer Controller IAM Policy JSON
data "http" "lbc_iam_policy" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.11.0/docs/install/iam_policy.json"
}



# Direct reference (without data)
#url = aws_eks_cluster.eks.identity[0].oidc[0].issuer



############################################################
# IAM OIDC PROVIDER FOR EKS
############################################################
resource "aws_iam_openid_connect_provider" "eks_oidc" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da0afd3b1f0"]  # EKS default thumbprint
  url             = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
}


 resource "aws_iam_policy" "lbc_iam_policy" {
   name        = "${var.project_name}-AWSLoadBalancerControllerIAMPolicy"
   path        = "/"
   description = "AWS Load Balancer Controller IAM Policy"
   policy      = data.http.lbc_iam_policy.body
 }



resource "aws_iam_role" "lbc_iam_role" {
  name = "${var.project_name}-lbc-iam-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRoleWithWebIdentity"
        Principal = {
          Federated = aws_iam_openid_connect_provider.eks_oidc.arn
        }
        Condition = {
          StringEquals = {
            "${replace(aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer, "https://", "")}:aud" = "sts.amazonaws.com"
            "${replace(aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer, "https://", "")}:sub" = "system:serviceaccount:kube-system:aws-load-balancer-controller"
          }
        }
      }
    ]
  })

  tags = {
    Name = "AWSLoadBalancerControllerIAMRole"
  }
}

