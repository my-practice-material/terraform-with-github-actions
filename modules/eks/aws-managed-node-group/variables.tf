variable "vpc_id" {
  type        = string
  description = "ID of the VPC to be used by the EKS Cluster"
  default     = ""
}

variable "cluster_security_group_id" {
  type        = string
  description = "ID of the security group associated with the EKS cluster"
  default     = ""
}

variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster to which the node group will be associated"
  default     = "study-eks-cluster"
}

variable "worker_node_name" {
  type        = string
  description = "Name of the IAM role to be used for the worker nodes in the node group"
  default     = "eksWorkerNodeRole"
}

variable "node_group_desired_capacity" {
  type        = number
  description = "Desired capacity of Node Group ASG."
  default     = 1
}
variable "node_group_max_size" {
  type        = number
  description = "Maximum size of Node Group ASG. Set to at least 1 greater than node_group_desired_capacity."
  default     = 2
}

variable "node_group_min_size" {
  type        = number
  description = "Minimum size of Node Group ASG."
  default     = 1
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

variable "cluster_endpoint" {
  type        = string
  description = "Endpoint URL for the EKS cluster API server"
  default     = ""
}

variable "certificate_authority_data" {
  type        = string
  description = "Base64 encoded certificate authority data for the EKS cluster"
  default     = ""  
}

variable "service_ipv4_cidr" {
  type        = string
  description = "CIDR block for Kubernetes service IP addresses in the EKS cluster"
  default     = "10.100.0.0/16" 
}