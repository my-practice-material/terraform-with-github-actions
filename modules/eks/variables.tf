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