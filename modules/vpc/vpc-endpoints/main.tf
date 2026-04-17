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