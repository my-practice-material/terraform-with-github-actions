# VPC Module

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.6.1"
  name = var.vpc_name
  cidr = var.vpc_cidr
  azs = var.azs
  private_subnets = var.private_subnets
  private_subnet_names = var.private_subnet_names
  public_subnets = var.public_subnets
  public_subnet_names = var.public_subnet_names
  map_public_ip_on_launch = true
  enable_dns_hostnames = true
  enable_dns_support = true   
}

