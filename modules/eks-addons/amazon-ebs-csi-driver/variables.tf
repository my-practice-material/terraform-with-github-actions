variable "aws_iam_openid_connect_provider_arn" {
  description = "ARN of the AWS IAM OpenID Connect provider for the EKS cluster"
  type        = string  
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resources created by this module"
  type        = map(string) 
}