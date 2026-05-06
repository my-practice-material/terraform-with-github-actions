resource "aws_iam_openid_connect_provider" "eks" {
  url             = data.aws_eks_cluster.this.identity[0].oidc[0].issuer
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks_oidc.certificates[0].sha1_fingerprint]
}

resource "aws_iam_role" "cluster_autoscaler_role" {
  name = "cluster-autoscaler-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.eks.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${replace(data.aws_eks_cluster.this.identity[0].oidc[0].issuer, "https://", "")}:sub" = "system:serviceaccount:kube-system:cluster-autoscaler"
          }
        }
      }
    ]
  })
}


resource "aws_iam_policy" "cluster_autoscaler_policy" {
  name        = "cluster_autoscaler_policy"
  description = "Cluster Autoscaler policy"
  policy     = file("${path.module}/iam-policy/cluster-autoscaler-policy.json")
}

# Attach the policy to the role
resource "aws_iam_role_policy_attachment" "cluster_autoscaler_policy_attachment" {
  role       = aws_iam_role.cluster_autoscaler_role.name
  policy_arn = aws_iam_policy.cluster_autoscaler_policy.arn
}


# Install cluster autoscaler using Helm
resource "helm_release" "cluster_autoscaler" {
  name       = "cluster-autoscaler"
  chart      = "${path.module}/helm"
  namespace  = "kube-system"

  values = [
    yamlencode({
      fullnameOverride = "cluster-autoscaler"
      autoDiscovery = {
        clusterName = var.cluster_name
      }
      awsRegion = data.aws_region.current.id
      rbac = {
        serviceAccount = {
          name = "cluster-autoscaler"
          annotations = {
            "eks.amazonaws.com/role-arn" = aws_iam_role.cluster_autoscaler_role.arn
          }
        }
      }
      tags = merge(
        var.tags
      )
    })
  ] 
}
