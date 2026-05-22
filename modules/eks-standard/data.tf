# Get current AWS account identity
data "aws_caller_identity" "current" {}

# Get current AWS region
data "aws_region" "current" {}

data "tls_certificate" "eks_oidc" {
  url = aws_eks_cluster.study-eks-cluster.identity[0].oidc[0].issuer
}

# Data source for existing GitHub OIDC provider
data "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"
}