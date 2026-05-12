variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to apply to the resources"
  type        = map(string)
  default     = {}
}

variable "aws_iam_openid_connect_provider_arn" {
  type        = string
  description = "ARN of the AWS IAM OpenID Connect provider for the EKS cluster"
  default     = ""
}

variable "vpc_cni_addon_version" {
  description = "The version of the Amazon VPC CNI addon to use for the EKS cluster"
  type        = string
  default     = "v1.21.1-eksbuild.1"  
}