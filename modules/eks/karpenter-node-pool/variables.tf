variable "vpc_id" {
  description = "The ID of the VPC where the EKS cluster is deployed"
  type        = string  
}

variable "cluster_security_group_id" {
  description = "The ID of the security group associated with the EKS cluster control plane"
  type        = string  
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string  
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


variable "tags" {
  description = "A map of tags to apply to all resources"
  type        = map(string)
  default     = {}  
}

variable "karpenter_controller_node_name" {
  description = "The name to apply to the Karpenter controller node group for identification in the AWS console"
  type        = string
  default     = "karpenter-controller-node-group"
}

variable "karpenter_worker_node_name" {
  description = "The name to apply to worker nodes for identification in the AWS console"
  type        = string
  default     = "karpenter-node-pool-worker-node"
}

variable "karpenter_node_role_arn" {
  description = "The ARN of the IAM role to associate with Karpenter nodes"
  type        = string
  default     = ""
}