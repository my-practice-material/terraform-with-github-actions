# This file is used to define the input variables for the Terraform configuration.

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to all resources."
  default     = {
    "environment" = "dev"
    "owner"       = "waghangad"
  } 
}

variable "bucket_name" {
  type        = string
  description = "AWS S3 Bucket Name."
  default     = "study-terraform-bucket"
}

variable "vpc_name" {
  type        = string
  description = "Name of the VPC"
  default     = "study-vpc"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
  default     = "10.10.0.0/20"
} 

variable "azs" {
  type        = list(string)
  description = "List of Availability Zones to use for subnets"
  default     = ["us-east-1a", "us-east-1b"]
}

variable "elb_public_subnets" {
  type        = list(string)
  description = "List of CIDR blocks for public subnets"
  default     = ["10.10.1.0/24", "10.10.2.0/24"]
}

variable "elb_public_subnets_names" {
  type        = list(string)
  description = "List of names for public subnets"
  default     = ["study-vpc-elb-pub-sbnt-az1", "study-vpc-elb-pub-sbnt-az2"]

}

variable "app_private_subnets" {
  type        = list(string)
  description = "List of CIDR blocks for private subnets for application servers"
  default     = ["10.10.3.0/24", "10.10.4.0/24"]
}

variable "app_private_subnet_names" {
  type        = list(string)
  description = "List of names for private subnets for application servers"
  default     = ["study-vpc-app-priv-sbnt-az1", "study-vpc-app-priv-sbnt-az2"] 
}

variable "db_private_subnets" {
  type        = list(string)
  description = "List of CIDR blocks for private subnets for database servers"
  default     = ["10.10.5.0/24", "10.10.6.0/24"]
}

variable "db_private_subnet_names" {
  type        = list(string)
  description = "List of names for private subnets for database servers"
  default     = ["study-vpc-db-priv-sbnt-az1", "study-vpc-db-priv-sbnt-az2"]  
}

variable "cluster_name" {
  type        = string
  description = "Name of the EKS Cluster"
  default     = "study-eks-cluster" 
}

variable "worker_node_name" {
  type        = string
  description = "Name of node role"
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

variable "cluster_admin_role_arn" {
  type        = string
  description = "ARN of the IAM Role to be granted admin access to the EKS Cluster"
  default     = "arn:aws:iam::123456789012:role/eks-cluster-admin"
}