# Create IAM role for Amazon VPC CNI Addons with trust relationship to the OIDC provider
resource "aws_iam_role" "vpc_cni_role" {
  name = "vpc-cni-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = var.aws_iam_openid_connect_provider_arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${replace(data.aws_eks_cluster.this.identity[0].oidc[0].issuer, "https://", "")}:sub" = "system:serviceaccount:kube-system:aws-node"
          }
        }
      }
    ]
  })
}

# Attach the AmazonEKS_CNI_Policy to the IAM role
resource "aws_iam_role_policy_attachment" "cluster_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.vpc_cni_role.name
  depends_on = [ aws_iam_role.vpc_cni_role ]
}

# Create the Amazon VPC CNI Addon for the EKS Cluster
resource "aws_eks_addon" "vpc_cni" {
  cluster_name             = var.cluster_name
  addon_name               = "vpc-cni"
  addon_version            = var.vpc_cni_addon_version
  service_account_role_arn = aws_iam_role.vpc_cni_role.arn
}