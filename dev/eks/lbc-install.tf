############################################################
# HELM RELEASE: AWS LOAD BALANCER CONTROLLER
############################################################
# Fetch first subnet from EKS cluster to get VPC ID
# Convert subnet_ids set to a list
locals {
  eks_subnet_list = tolist(data.aws_eks_cluster.eks.vpc_config[0].subnet_ids)
}

# Fetch first subnet from EKS cluster to get VPC ID
data "aws_subnet" "first" {
  id = local.eks_subnet_list[0]
}

# Get VPC ID dynamically
data "aws_vpc" "eks_vpc" {
  id = data.aws_subnet.first.vpc_id
}




resource "helm_release" "loadbalancer_controller" {
  depends_on = [aws_iam_role.lbc_iam_role]            
  name       = "aws-load-balancer-controller-${var.project_name}"

  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"

  set {
    name  = "image.repository"
    value = "602401143452.dkr.ecr.ap-south-1.amazonaws.com/amazon/aws-load-balancer-controller" # Adjust for your region
  }       

  set {
    name  = "serviceAccount.create"
    value = "true"
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.lbc_iam_role.arn
  }

  set {
    name  = "vpcId"
    value = data.aws_vpc.eks_vpc.id
  }  

  set {
    name  = "region"
    value = var.aws_region
  }    

  set {
    name  = "clusterName"
    value = var.project_name
  }    
}