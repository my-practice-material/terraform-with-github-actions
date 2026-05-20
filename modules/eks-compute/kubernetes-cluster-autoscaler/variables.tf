variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster to which the node group will be associated"
  default     = "study-eks-cluster"
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to the resources created by this module"
  default     = {}  
}

variable "aws_iam_openid_connect_provider_arn" {
  type        = string
  description = "ARN of the AWS IAM OpenID Connect provider for the EKS cluster"
  default     = ""
}