# Create S3 bucket with a unique name using the current AWS account ID
# module "create_s3_bucket" {
#     source        = "./modules/s3"
#     bucket_name   = "${var.bucket_name}-${data.aws_caller_identity.current.account_id}"
# }

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
    cluster_name                = var.cluster_name
    tags                        = var.tags
}

# Create EKS cluster using the private subnets from the VPC module
module "create_eks" {
    source = "./modules/eks"
    cluster_name = var.cluster_name
    private_subnet_ids = module.create_vpc.private_subnets
    public_subnet_ids = module.create_vpc.public_subnets
    cluster_admin_role_arn = var.cluster_admin_role_arn
    tags = var.tags
    depends_on = [ module.create_vpc ]
}

# Create self-managed node group for EKS cluster.
# module "eks_self_managed_node_group" {
#     source = "./modules/eks/self-managed-node-group"
#     vpc_id = module.create_vpc.vpc_id
#     worker_node_name = var.worker_node_name
#     private_subnet_ids = module.create_vpc.private_subnets
#     public_subnet_ids = module.create_vpc.public_subnets
#     cluster_security_group_id = module.create_eks.cluster_security_group_id
#     cluster_name = var.cluster_name
#     node_group_desired_capacity = var.node_group_desired_capacity
#     node_group_max_size = var.node_group_max_size
#     node_group_min_size = var.node_group_min_size
#     depends_on = [ module.create_eks ]
# }

# Create AWS Managed Node Group for EKS cluster.
# module "eks_aws_managed_node_group" {
#     source = "./modules/eks/aws-managed-node-group"
#     vpc_id = module.create_vpc.vpc_id
#     worker_node_name = var.worker_node_name
#     private_subnet_ids = module.create_vpc.private_subnets
#     public_subnet_ids = module.create_vpc.public_subnets
#     cluster_security_group_id = module.create_eks.cluster_security_group_id
#     cluster_name = var.cluster_name
#     node_group_desired_capacity = var.node_group_desired_capacity
#     node_group_max_size = var.node_group_max_size
#     node_group_min_size = var.node_group_min_size
#     certificate_authority_data = module.create_eks.certificate_authority_data
#     cluster_endpoint = module.create_eks.cluster_endpoint
#     service_ipv4_cidr = module.create_eks.service_ipv4_cidr
#     depends_on = [ module.create_eks ]
# }

# module "fargate_profile" {
#     source = "./modules/eks/fargate-profile"
#     cluster_name = var.cluster_name
#     private_subnet_ids = module.create_vpc.private_subnets
#     tags = var.tags
#     depends_on = [ module.create_eks ]
# }

# Create AWS Managed Node Group for EKS cluster.
module "karpenter_aws_managed_node_group" {
    source = "./modules/eks/karpenter-node-group"
    vpc_id = module.create_vpc.vpc_id
    karpenter_controller_node_name = var.karpenter_controller_node_name
    private_subnet_ids = module.create_vpc.private_subnets
    public_subnet_ids = module.create_vpc.public_subnets
    cluster_security_group_id = module.create_eks.cluster_security_group_id
    cluster_name = var.cluster_name
    node_group_desired_capacity = var.node_group_desired_capacity
    node_group_max_size = var.node_group_max_size
    node_group_min_size = var.node_group_min_size
    certificate_authority_data = module.create_eks.certificate_authority_data
    cluster_endpoint = module.create_eks.cluster_endpoint
    service_ipv4_cidr = module.create_eks.service_ipv4_cidr
    coredns_addon_version = var.coredns_addon_version
    depends_on = [ module.create_eks ]
}

module "karpenter-controller" {
  source = "./modules/eks/karpenter-controller"
  cluster_name = var.cluster_name
  tags = var.tags
  depends_on = [ module.create_eks, module.karpenter_aws_managed_node_group ]
}

module "karpenter_worker_node-pool" {
  source                      = "./modules/eks/karpenter-node-pool"
  cluster_name                = var.cluster_name
  certificate_authority_data  = module.create_eks.certificate_authority_data
  cluster_endpoint            = module.create_eks.cluster_endpoint
  service_ipv4_cidr           = module.create_eks.service_ipv4_cidr
  vpc_id                      = module.create_vpc.vpc_id
  cluster_security_group_id   = module.create_eks.cluster_security_group_id
  karpenter_worker_node_name  = var.karpenter_worker_node_name
  karpenter_controller_node_name = var.karpenter_controller_node_name
  karpenter_node_role_arn     = module.karpenter_aws_managed_node_group.karpenter_node_group_iam_role_arn
  depends_on                  = [ module.karpenter-controller ]
}