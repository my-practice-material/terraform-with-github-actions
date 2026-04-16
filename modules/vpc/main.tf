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
  enable_dns_hostnames = true
  enable_dns_support = true   
}

module "vpc_endpoints" {
  source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "6.6.1"
  vpc_id = module.vpc.vpc_id
  endpoints = {
    s3 = {
        service = "s3"
        service_type    = "Gateway"
        route_table_ids = module.vpc.private_route_table_ids
        tags            = { Name = "s3-gateway-endpoint" }
    }
  }
}

# resource "aws_customer_gateway" "study_customer_gateway" {
#   bgp_asn    = 65000
#   ip_address = "172.83.124.10"
#   type       = "ipsec.1"

#   tags = {
#     Name = "study-customer-gateway"
#   }
# }

resource "aws_security_group" "tf-study-sg" {
  name        = "tf-study-sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "tf-study-sg"
  }
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.tf-study-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}