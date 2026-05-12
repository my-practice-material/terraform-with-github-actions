variable "vpc_id" {
  type        = string
  description = "ID of the VPC to be used by the EKS Cluster"
  default     = ""
}

variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster to which the node group will be associated"
  default     = "study-eks-cluster"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of IDs for private subnets to be used by the EKS Cluster"
  default     = []
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "List of IDs for public subnets to be used by the EKS Cluster"
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to all resources in the EKS self-managed node group module."
  default     = {
    "environment" = "dev"
    "owner"       = "Angad Wagh"
  }
}

variable "aws_iam_openid_connect_provider_arn" {
  type        = string
  description = "ARN of the AWS IAM OpenID Connect provider for the EKS cluster"
  default     = ""
}