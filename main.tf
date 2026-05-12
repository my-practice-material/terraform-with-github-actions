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
    cluster_name                = var.eks_cluster_name
    tags                        = var.tags
}

# Create EKS cluster-standard.
module "create_eks_standard_cluster" {
    source = "./modules/eks-standard"
    cluster_name = var.eks_cluster_name
    private_subnet_ids = module.create_vpc.private_subnets
    public_subnet_ids = module.create_vpc.public_subnets
    cluster_admin_role_arn = var.cluster_admin_role_arn
    tags = var.tags
    depends_on = [ module.create_vpc ]
}

# Deploy Amazon VPC CNI Addon for EKS cluster.
module "install_vpc_cni" {
  source = "./modules/eks-addons/amazon-vpc-cni"
  cluster_name = var.eks_cluster_name
  vpc_cni_addon_version = var.vpc_cni_addon_version
  aws_iam_openid_connect_provider_arn = module.create_eks_standard_cluster.aws_iam_openid_connect_provider_arn
  tags = var.tags
  depends_on = [ module.create_eks_standard_cluster ]
}

# Create EKS cluster-auto-mode.
# module "create_eks_auto_mode_cluster" {
#     source = "./modules/eks-auto-mode"
#     cluster_name = var.eks_cluster_name
#     private_subnet_ids = module.create_vpc.private_subnets
#     public_subnet_ids = module.create_vpc.public_subnets
#     cluster_admin_role_arn = var.cluster_admin_role_arn
#     tags = var.tags
#     depends_on = [ module.create_vpc ]
# }

# Create self-managed node group for EKS cluster with AL2 AMI.
# module "create_self_managed_node_group_al2" {
#     source = "./modules/eks-standard/self-managed-node-group-al2"
#     vpc_id = module.create_vpc.vpc_id
#     worker_node_name = var.worker_node_name
#     private_subnet_ids = module.create_vpc.private_subnets
#     public_subnet_ids = module.create_vpc.public_subnets
#     cluster_security_group_id = module.create_eks_standard_cluster.cluster_security_group_id
#     cluster_name = var.eks_cluster_name
#     node_group_desired_capacity = var.node_group_desired_capacity
#     node_group_max_size = var.node_group_max_size
#     node_group_min_size = var.node_group_min_size
#     depends_on = [ module.create_eks_standard_cluster, module.install_vpc_cni ]
# }

# Create AWS Managed Node Group for EKS cluster with AL2023 AMI.
# module "create_managed_node_group_al2023" {
#     source = "./modules/eks-standard/managed-node-group-al2023"
#     vpc_id = module.create_vpc.vpc_id
#     worker_node_name = var.worker_node_name
#     private_subnet_ids = module.create_vpc.private_subnets
#     public_subnet_ids = module.create_vpc.public_subnets
#     cluster_security_group_id = module.create_eks_standard_cluster.cluster_security_group_id
#     cluster_name = var.eks_cluster_name
#     node_group_desired_capacity = var.node_group_desired_capacity
#     node_group_max_size = var.node_group_max_size
#     node_group_min_size = var.node_group_min_size
#     certificate_authority_data = module.create_eks_standard_cluster.certificate_authority_data
#     cluster_endpoint = module.create_eks_standard_cluster.cluster_endpoint
#     service_ipv4_cidr = module.create_eks_standard_cluster.service_ipv4_cidr
#     depends_on = [ module.create_eks_standard_cluster, module.install_vpc_cni ]
# }

# module "deploy_cluster_autoscaler" {
#   source = "./modules/eks-standard/cluster-autoscaler"
#   cluster_name = var.eks_cluster_name
#   aws_iam_openid_connect_provider_arn = module.create_eks_standard_cluster.aws_iam_openid_connect_provider_arn
#   tags = var.tags
#   depends_on = [ module.create_managed_node_group_al2023 ]
# }

# Create AWS Managed Node Group for EKS cluster with Bottlerocket AMI.
# module "create_managed_node_group-bottlerocket" {
#     source = "./modules/eks-standard/managed-node-group-bottlerocket"
#     vpc_id = module.create_vpc.vpc_id
#     worker_node_name = var.worker_node_name
#     private_subnet_ids = module.create_vpc.private_subnets
#     public_subnet_ids = module.create_vpc.public_subnets
#     cluster_security_group_id = module.create_eks_standard_cluster.cluster_security_group_id
#     cluster_name = var.eks_cluster_name
#     node_group_desired_capacity = var.node_group_desired_capacity
#     node_group_max_size = var.node_group_max_size
#     node_group_min_size = var.node_group_min_size
#     certificate_authority_data = module.create_eks_standard_cluster.certificate_authority_data
#     cluster_endpoint = module.create_eks_standard_cluster.cluster_endpoint
#     service_ipv4_cidr = module.create_eks_standard_cluster.service_ipv4_cidr
#     depends_on = [ module.create_eks_standard_cluster, module.install_vpc_cni ]
# }

# Create Fargate Profile for EKS cluster.
# module "create-fargate_profile" {
#     source = "./modules/eks-standard/fargate-profile"
#     cluster_name = var.eks_cluster_name
#     private_subnet_ids = module.create_vpc.private_subnets
#     tags = var.tags
#     depends_on = [ module.create_eks_standard_cluster ]
# }

# Create AWS Managed Node Group for EKS cluster with AL2023 AMI.
module "create_karpenter_node_group_al2023" {
    source = "./modules/eks-standard/karpenter-node-group-al2023"
    vpc_id = module.create_vpc.vpc_id
    karpenter_controller_node_name = var.karpenter_controller_node_name
    private_subnet_ids = module.create_vpc.private_subnets
    public_subnet_ids = module.create_vpc.public_subnets
    cluster_security_group_id = module.create_eks_standard_cluster.cluster_security_group_id
    cluster_name = var.eks_cluster_name
    node_group_desired_capacity = var.node_group_desired_capacity
    node_group_max_size = var.node_group_max_size
    node_group_min_size = var.node_group_min_size
    certificate_authority_data = module.create_eks_standard_cluster.certificate_authority_data
    cluster_endpoint = module.create_eks_standard_cluster.cluster_endpoint
    service_ipv4_cidr = module.create_eks_standard_cluster.service_ipv4_cidr
    coredns_addon_version = var.coredns_addon_version
    depends_on = [ module.create_eks_standard_cluster, module.install_vpc_cni ]
}

# Deploy Karpenter controller for EKS cluster.
module "deploy-karpenter-controller" {
  source = "./modules/eks-standard/karpenter-controller"
  cluster_name = var.eks_cluster_name
  aws_iam_openid_connect_provider_arn = module.create_eks_standard_cluster.aws_iam_openid_connect_provider_arn
  tags = var.tags
  depends_on = [ module.create_eks_standard_cluster, module.create_karpenter_node_group_al2023 ]
}

# Create Karpenter node pool for EKS cluster.
module "create_karpenter_node_pool_al2023" {
  source                      = "./modules/eks-standard/karpenter-node-pool-al2023"
  cluster_name                = var.eks_cluster_name
  certificate_authority_data  = module.create_eks_standard_cluster.certificate_authority_data
  cluster_endpoint            = module.create_eks_standard_cluster.cluster_endpoint
  service_ipv4_cidr           = module.create_eks_standard_cluster.service_ipv4_cidr
  vpc_id                      = module.create_vpc.vpc_id
  cluster_security_group_id   = module.create_eks_standard_cluster.cluster_security_group_id
  karpenter_worker_node_name  = var.karpenter_worker_node_name
  karpenter_controller_node_name = var.karpenter_controller_node_name
  karpenter_node_role_arn     = module.create_karpenter_node_group_al2023.karpenter_node_group_iam_role_arn
  depends_on                  = [ module.deploy-karpenter-controller ]
}

# Deploy Ingress Controller for EKS cluster.
module "install_ingress_controller" {
  source = "./modules/eks-addons/ingress-controller"
  cluster_name = var.eks_cluster_name
  vpc_id = module.create_vpc.vpc_id
  aws_iam_openid_connect_provider_arn = module.create_eks_standard_cluster.aws_iam_openid_connect_provider_arn
  tags = var.tags
  depends_on = [ module.create_karpenter_node_pool_al2023 ]
}