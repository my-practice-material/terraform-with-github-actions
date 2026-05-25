# AWS IAM OpenID Connect provider for GitHub Actions is already created for terraform github repository.
#  resource "aws_iam_openid_connect_provider" "github" {
#   url             = "https://token.actions.githubusercontent.com"
#   client_id_list  = ["sts.amazonaws.com"]
#   thumbprint_list = [data.tls_certificate.eks_oidc.certificates[0].sha1_fingerprint]
# }

resource "aws_iam_role" "github_actions_oidc" {
  name = "github-actions-eks-deploy-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = data.aws_iam_openid_connect_provider.github.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
              "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
          StringLike = {
              "token.actions.githubusercontent.com:sub" = "repo:my-practice-material/*"
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "github_actions_role_policy" {
  name        = "github-actions-eks-deploy-policy"
  description = "Policy for GitHub Actions to deploy to EKS cluster"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "eks:Describe*",
          "eks:List*",
          "eks:AccessKubernetesApi"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart",
          "ecr:DescribeRepositories",
          "ecr:ListImages"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_admin_attach" {
  role       = aws_iam_role.github_actions_oidc.name
  policy_arn = aws_iam_policy.github_actions_role_policy.arn
}
