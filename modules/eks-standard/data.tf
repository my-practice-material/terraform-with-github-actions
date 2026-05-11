# Get current AWS account identity
data "aws_caller_identity" "current" {}

# Get current AWS region
data "aws_region" "current" {}

data "tls_certificate" "eks_oidc" {
  url = aws_eks_cluster.study-eks-cluster.identity[0].oidc[0].issuer
}