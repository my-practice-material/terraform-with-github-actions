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

variable "vpc_id" {
  description = "The ID of the VPC where the EKS cluster is deployed"
  type        = string
  default     = ""
}