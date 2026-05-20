# Create IAM role for Amazon EFS CSI Driver with trust relationship to the OIDC provider
resource "aws_iam_role" "efs_csi_driver_role" {
  name = "efs-csi-driver-role"

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
            "${replace(data.aws_eks_cluster.this.identity[0].oidc[0].issuer, "https://", "")}:sub": "system:serviceaccount:kube-system:efs-csi-controller-sa",
            "${replace(data.aws_eks_cluster.this.identity[0].oidc[0].issuer, "https://", "")}:aud": "sts.amazonaws.com"
          }
        }
      }
    ]
  })
}

# Attach the AmazonEFSCSIDriverPolicy to the IAM role
resource "aws_iam_role_policy_attachment" "cluster_AmazonEFSCSIDriverPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"
  role       = aws_iam_role.efs_csi_driver_role.name
  depends_on = [ aws_iam_role.efs_csi_driver_role ]
}

# Install the Amazon EFS CSI Driver using Helm
resource "helm_release" "efs_csi_driver" { 
  name       = "aws-efs-csi-driver"
  namespace  = "kube-system"
  repository = "https://kubernetes-sigs.github.io/aws-efs-csi-driver"
  chart      = "aws-efs-csi-driver"
  version    = "4.2.0"
  timeout    = 600   # wait up to 10 minutes for the deployment to complete
  values     = [
    yamlencode({
      fullnameOverride: "aws-efs-csi-driver"
      controller = {
        serviceAccount = {
          create = true
          name   = "efs-csi-controller-sa"
          annotations = {
            "eks.amazonaws.com/role-arn" = aws_iam_role.efs_csi_driver_role.arn
          }
        }
      }
    })
  ]
}
