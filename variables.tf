# This file is used to define the input variables for the Terraform configuration.

variable "bucket_name" {
  type        = string
  description = "AWS S3 Bucket Name."
  default     = "study"
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

variable "public_subnets" {
  type        = list(string)
  description = "List of CIDR blocks for public subnets"
  default     = ["10.10.1.0/24", "10.10.2.0/24"]
}

variable "public_subnet_names" {
  type        = list(string)
  description = "List of names for public subnets"
  default     = ["study-vpc-pub-sbnt-az1", "study-vpc-pub-sbnt-az2"]
  
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