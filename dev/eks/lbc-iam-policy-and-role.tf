# ############################################################
# # VARIABLES
# ############################################################

# ############################################################
# # DATA SOURCES
# ############################################################

# # Fetch EKS cluster details dynamically (cluster name = project_name)
# data "aws_eks_cluster" "eks" {
#   name = var.project_name
# }

# data "aws_eks_cluster_auth" "eks" {
#   name = var.project_name
# }

# # AWS Load Balancer Controller IAM Policy JSON
# data "http" "lbc_iam_policy" {
#   url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.11.0/docs/install/iam_policy.json"
# }

# ############################################################
# # IAM OIDC PROVIDER FOR EKS
# ############################################################
# resource "aws_iam_openid_connect_provider" "eks_oidc" {
#   client_id_list  = ["sts.amazonaws.com"]
#   thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da0afd3b1f0"]  # EKS default thumbprint
#   url             = data.aws_eks_cluster.eks.identity[0].oidc[0].issuer
# }

# ############################################################
# # CREATE IAM POLICY FOR LBC
# ############################################################
# resource "aws_iam_policy" "lbc_iam_policy" {
#   name        = "${var.project_name}-AWSLoadBalancerControllerIAMPolicy"
#   path        = "/"
#   description = "AWS Load Balancer Controller IAM Policy"
#   policy      = data.http.lbc_iam_policy.body
# }

# output "lbc_iam_policy_arn" {
#   value = aws_iam_policy.lbc_iam_policy.arn
# }

# ############################################################
# # CREATE IAM ROLE FOR SERVICE ACCOUNT
# ############################################################
# resource "aws_iam_role" "lbc_iam_role" {
#   name = "${var.project_name}-lbc-iam-role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Action = "sts:AssumeRoleWithWebIdentity"
#         Principal = {
#           Federated = aws_iam_openid_connect_provider.eks_oidc.arn
#         }
#         Condition = {
#           StringEquals = {
#             "${replace(data.aws_eks_cluster.eks.identity[0].oidc[0].issuer, "https://", "")}:aud" = "sts.amazonaws.com"
#             "${replace(data.aws_eks_cluster.eks.identity[0].oidc[0].issuer, "https://", "")}:sub" = "system:serviceaccount:kube-system:aws-load-balancer-controller"
#           }
#         }
#       }
#     ]
#   })

#   tags = {
#     Name = "AWSLoadBalancerControllerIAMRole"
#   }
# }

# output "lbc_iam_role_arn" {
#   value = aws_iam_role.lbc_iam_role.arn
# }

# ############################################################
# # ATTACH POLICY TO ROLE
# ############################################################
# resource "aws_iam_role_policy_attachment" "lbc_iam_role_policy_attach" {
#   policy_arn = aws_iam_policy.lbc_iam_policy.arn
#   role       = aws_iam_role.lbc_iam_role.name
# }
