# Create S3 bucket with a unique name using the current AWS account ID
module "create_s3_bucket" {
    source        = "./modules/s3"
    bucket_name   = "${var.bucket_name}-${data.aws_caller_identity.current.account_id}"
}

# Create VPC with public and private subnets
module "create_vpc" {
    source                      = "./modules/vpc"
    vpc_name                    = var.vpc_name
    vpc_cidr                    = var.vpc_cidr
    azs                         = var.azs
    public_subnets              = var.elb_public_subnets
    public_subnet_names         = var.elb_public_subnets_names
    private_subnets             = concat(var.app_private_subnets, var.db_private_subnets)
    private_subnet_names        = concat(var.app_private_subnet_names, var.db_private_subnet_names)
}

# Create EKS cluster using the private subnets from the VPC module
module "create_eks" {
    source = "./modules/eks"
    cluster_name = var.cluster_name
    private_subnet_ids = module.create_vpc.private_subnets
    public_subnet_ids = module.create_vpc.public_subnets
    cluster_admin_role_arn = var.cluster_admin_role_arn
    tags = var.tags
}

module "eks_self_managed_node_group" {
    source = "./modules/eks/self-managed-node-group"
    vpc_id = module.create_vpc.vpc_id
    worker_node_name = var.worker_node_name
    private_subnet_ids = module.create_vpc.private_subnets
    public_subnet_ids = module.create_vpc.public_subnets
    cluster_security_group_id = module.create_eks.cluster_security_group_id
    cluster_name = var.cluster_name
    node_group_desired_capacity = var.node_group_desired_capacity
    node_group_max_size = var.node_group_max_size
    node_group_min_size = var.node_group_min_size
    depends_on = [ module.create_eks ]
}