# Get current AWS account identity
data "aws_caller_identity" "current" {}

# module "create_s3_bucket" {
#     source        = "./modules/s3"
#     bucket_name   = "${var.bucket_name}-${data.aws_caller_identity.current.account_id}"
# }

module "create_vpc" {
    source                      = "./modules/vpc"
    vpc_name                    = var.vpc_name
    vpc_cidr                    = var.vpc_cidr
    azs                         = var.azs
    public_subnets              = var.public_subnets
    public_subnet_names         = var.public_subnet_names
    private_subnets             = concat(var.app_private_subnets, var.db_private_subnets)
    private_subnet_names        = concat(var.app_private_subnet_names, var.db_private_subnet_names)
}