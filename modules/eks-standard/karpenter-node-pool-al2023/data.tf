data "aws_eks_cluster" "this" {
  name = var.cluster_name
}

data "tls_certificate" "eks_oidc" {
  url = data.aws_eks_cluster.this.identity[0].oidc[0].issuer
}

# Get AMI ID for latest recommended Amazon Linux 2023 EKS optimized AMI for Kubernetes version 1.35
data "aws_ssm_parameter" "node_ami" {
  name = "/aws/service/eks/optimized-ami/1.35/amazon-linux-2023/x86_64/standard/recommended/image_id"
}

# Get current AWS account identity
data "aws_caller_identity" "current" {}

# Get the IAM role created for Karpenter controller node.
data "aws_iam_role" "karpenter-controller-node-role" {
  name = "karpenter-controller-node-role"
}