variable "cluster_name" {
  type        = string
  description = "Name of the EKS Cluster"
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
  description = "A map of tags to assign to all resources in the EKS module."
  default     = {
    "environment" = "dev"
    "owner"       = "Angad Wagh"
  }
}

variable "cluster_admin_role_arn" {
  type        = string
  description = "ARN of the IAM Role to be used as cluster admin for EKS Cluster access"
  default     = ""
}
