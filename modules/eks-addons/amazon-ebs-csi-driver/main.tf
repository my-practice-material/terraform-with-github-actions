# Create IAM role for Amazon EBS CSI Driver with trust relationship to the OIDC provider
resource "aws_iam_role" "ebs_csi_driver_role" {
  name = "ebs-csi-driver-role"

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
            "${replace(data.aws_eks_cluster.this.identity[0].oidc[0].issuer, "https://", "")}:sub": "system:serviceaccount:kube-system:ebs-csi-controller-sa",
            "${replace(data.aws_eks_cluster.this.identity[0].oidc[0].issuer, "https://", "")}:aud": "sts.amazonaws.com"
          }
        }
      }
    ]
  })
}

# Attach the AmazonEBSCSIDriverPolicyV2 to the IAM role
resource "aws_iam_role_policy_attachment" "cluster_AmazonEBSCSIDriverPolicyV2" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEBSCSIDriverPolicyV2"
  role       = aws_iam_role.ebs_csi_driver_role.name
  depends_on = [ aws_iam_role.ebs_csi_driver_role ]
}

# Install the Amazon EBS CSI Driver using Helm
resource "helm_release" "ebs_csi_driver" { 
  name       = "aws-ebs-csi-driver"
  namespace  = "kube-system"
  repository = "https://kubernetes-sigs.github.io/aws-ebs-csi-driver"
  chart      = "aws-ebs-csi-driver"
  version    = "2.59.0"
  timeout    = 600   # wait up to 10 minutes for the deployment to complete
  values     = [
    yamlencode({
      fullnameOverride: "aws-ebs-csi-driver"
      controller = {
        serviceAccount = {
          create = true
          name   = "ebs-csi-controller-sa"
          annotations = {
            "eks.amazonaws.com/role-arn" = aws_iam_role.ebs_csi_driver_role.arn
          }
        }
      }
    })
  ]
}
