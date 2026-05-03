resource "aws_iam_openid_connect_provider" "eks" {
  url             = data.aws_eks_cluster.this.identity[0].oidc[0].issuer
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks_oidc.certificates[0].sha1_fingerprint]
}

resource "aws_iam_role" "karpenter_controller_role" {
  name = "karpenter-controller-role"

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
            "${replace(data.aws_eks_cluster.this.identity[0].oidc[0].issuer, "https://", "")}:sub" = "system:serviceaccount:karpenter:karpenter-sa"
          }
        }
      }
    ]
  })
}


resource "aws_iam_policy" "karpenter_controller_policy" {
  name= "karpenter_controller_policy"
  description = "karpenter controller policy"
  policy = file("${path.module}/iam-policy/karpenter-controller-policy.json")
}

# Or use the recommended Karpenter controller policy JSON from AWS docs
resource "aws_iam_role_policy_attachment" "karpenter_controller_policy_attachment" {
  role       = aws_iam_role.karpenter_controller_role.name
  policy_arn = aws_iam_policy.karpenter_controller_policy.arn
}


# Install Karpenter CRDs first
resource "helm_release" "karpenter_crd" {
  name             = "karpenter-crd"
  repository       = "oci://public.ecr.aws/karpenter"
  chart            = "karpenter-crd"
  namespace        = "karpenter"
  version          = "1.12.0"
  create_namespace = true
  force_update     = true
}

# Sleep resource
resource "time_sleep" "wait_for_crds" {
  depends_on = [helm_release.karpenter_crd]

  create_duration = "30s"   # adjust as needed
}

# Install Karpenter controller after CRDs
resource "helm_release" "karpenter" {
  name             = "karpenter"
  repository       = "oci://public.ecr.aws/karpenter"
  chart            = "karpenter"
  version          = "1.12.0"
  namespace        = "karpenter"
  create_namespace = true
  force_update     = true

  # Ensure CRDs are installed first
  depends_on = [helm_release.karpenter_crd, time_sleep.wait_for_crds]

  values = [
    yamlencode({
      serviceAccount = {
        create = true
        name   = "karpenter-sa"
        annotations = {
          "eks.amazonaws.com/role-arn" = aws_iam_role.karpenter_controller_role.arn
        }
      }
      settings = {
        clusterName      = var.cluster_name
        clusterEndpoint  = data.aws_eks_cluster.this.endpoint
        clusterCA        = data.aws_eks_cluster.this.certificate_authority[0].data
      }
      podLabels = {
        "app.kubernetes.io/name" = "karpenter"
      }
      tolerations = [
        {
          key      = "karpenter.sh/controller"
          operator = "Equal"
          value    = "true"
          effect   = "NoSchedule"
        }
      ]
    })
  ] 
}

