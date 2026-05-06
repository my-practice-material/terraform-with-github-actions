# resource "aws_kms_key" "eks_cluster_kms_key" {
#   description             = "KMS key for EKS cluster"
#   deletion_window_in_days = 7
#   enable_key_rotation     = true
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Id      = "allow-root-account-to-manage-key"
#     Statement = [
#       {
#         Sid       = "AllowRootAccountToManageKey"
#         Effect    = "Allow"
#         Principal = {
#           AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
#         }
#         Action    = "kms:*"
#         Resource  = "*"
#       },
#       {
#         Sid    = "AllowAdminAccessToKMSKey"
#         Effect = "Allow"
#         Principal = {
#           AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-reserved/sso.amazonaws.com/ap-south-1/AWSReservedSSO_AdministratorAccess_c3baec8c61b153ee"
#         }
#         Action   = "kms:*"
#         Resource = "*"
#       },
#       {
#         Sid    = "AllowCloudWatchLogs"
#         Effect = "Allow"
#         Principal = {
#           Service = "logs.us-east-1.amazonaws.com"
#         }
#         Action = [
#           "kms:Encrypt",
#           "kms:Decrypt",
#           "kms:ReEncrypt*",
#           "kms:GenerateDataKey*",
#           "kms:DescribeKey"
#         ]
#         Resource = "*"
#       },
#       {
#         Sid    = "AllowClusterRole"
#         Effect = "Allow"
#         Principal = {
#           AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.cluster_name}-role"
#         }
#         Action = [
#           "kms:Encrypt",
#           "kms:Decrypt",
#           "kms:ReEncrypt*",
#           "kms:GenerateDataKey*",
#           "kms:DescribeKey",
#           "kms:createGrant"
#         ]
#         Resource = "*"
#       },
#       {
#         Sid    = "AllowAutoScalingServiceLinkedRole"
#         Effect = "Allow"
#         Principal = {
#           AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
#         }
#         Action = [
#           "kms:Encrypt",
#           "kms:Decrypt",
#           "kms:ReEncrypt*",
#           "kms:GenerateDataKey*",
#           "kms:DescribeKey",
#           "kms:createGrant"
#         ]
#         Resource = "*"
#       },
#       # Allow Karpenter controller role to use the KMS key for EKS cluster secrets encryption. Add this only after karpenter controller role is created, otherwise it will cause circular dependency issue.
#       {
#         Sid    = "KarpenterControllerAccessToKMSKey"
#         Effect = "Allow"
#         Principal = {
#           AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/karpenter-controller-role"
#         }
#         Action = [
#           "kms:Encrypt",
#           "kms:Decrypt",
#           "kms:ReEncrypt*",
#           "kms:GenerateDataKey*",
#           "kms:DescribeKey",
#           "kms:createGrant"
#         ]
#         Resource = "*"
#       }
#     ]
#   })
# }

# resource "aws_kms_alias" "eks_cluster_kms_alias" {
#   name          = "alias/CMK/EKS"
#   target_key_id = aws_kms_key.eks_cluster_kms_key.id
#   depends_on = [ aws_kms_key.eks_cluster_kms_key ]
# }