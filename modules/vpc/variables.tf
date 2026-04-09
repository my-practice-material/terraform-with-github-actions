variable "vpc_name" {
  type        = string
  description = "Name of the VPC"
  default     = "my-vpc"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "azs" {
  type        = list(string)
  description = "List of Availability Zones for the VPC"
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
  default     = ["my-vpc-pub-sbnt-az1", "my-vpc-pub-sbnt-az2"]
}

variable "private_subnets" {
  type        = list(string)
  description = "List of CIDR blocks for private subnets for application servers"
  default     = ["10.10.3.0/24", "10.10.4.0/24"]
}

variable "private_subnet_names" {
  type        = list(string)
  description = "List of names for private subnets for application servers"
  default     = ["my-vpc-app-priv-sbnt-az1", "my-vpc-app-priv-sbnt-az2"] 
}