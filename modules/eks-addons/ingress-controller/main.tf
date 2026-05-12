# Create IAM role for ingress controller with trust relationship to the OIDC provider
resource "aws_iam_role" "ingress_controller_role" {
  name = "ingress-controller-role"

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
            "${replace(data.aws_eks_cluster.this.identity[0].oidc[0].issuer, "https://", "")}:sub" = "system:serviceaccount:kube-system:ingress-controller-sa"
          }
        }
      }
    ]
  })
}

# Create IAM policy for ingress controller
resource "aws_iam_policy" "ingress_controller_policy" {
  name        = "ingress_controller_policy"
  description = "Ingress Controller policy"
  policy     = file("${path.module}/iam-policy/ingress-controller-policy.json")
}

# Attach the policy to the role
resource "aws_iam_role_policy_attachment" "ingress_controller_policy_attachment" {
  role       = aws_iam_role.ingress_controller_role.name
  policy_arn = aws_iam_policy.ingress_controller_policy.arn
}

resource "helm_release" "ingress_controller" {
  name       = "ingress-controller"
  namespace  = "kube-system"

  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = "1.7.1"

  values = [
    yamlencode({
      clusterName = var.cluster_name
      vpcId       = var.vpc_id 
      serviceAccount = {
        create = true
        name   = "ingress-controller-sa"
        annotations = {
          "eks.amazonaws.com/role-arn" = aws_iam_role.ingress_controller_role.arn
        }
      }
      tags = var.tags
    })
  ]
}
