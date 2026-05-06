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