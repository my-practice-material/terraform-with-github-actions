# Terraform Variables for Dev Environment in US East 1 Region

tags = {
  "environment" = "dev"
  "owner"       = "waghangad"
}

bucket_name = "study-terraform-bucket"

# VPC Configuration
vpc_name = "study-vpc"
vpc_cidr = "10.10.0.0/20"
azs = ["us-east-1a", "us-east-1b"]
elb_public_subnets = ["10.10.1.0/24", "10.10.2.0/24"]
elb_public_subnets_names = ["study-vpc-elb-pub-sbnt-az1", "study-vpc-elb-pub-sbnt-az2"]
app_private_subnets = ["10.10.3.0/24", "10.10.4.0/24"]
app_private_subnet_names = ["study-vpc-app-priv-sbnt-az1", "study-vpc-app-priv-sbnt-az2"]
db_private_subnets = ["10.10.5.0/24", "10.10.6.0/24"]
db_private_subnet_names = ["study-vpc-db-priv-sbnt-az1", "study-vpc-db-priv-sbnt-az2"]

# EKS Cluster Configuration
cluster_name = "study-eks-cluster"
worker_node_name = "study-eks-worker-node"
node_group_desired_capacity = 2
node_group_max_size = 3
node_group_min_size = 1
cluster_admin_role = "arn:aws:iam::360496493654:role/aws-reserved/sso.amazonaws.com/ap-south-1/AWSReservedSSO_AdministratorAccess_c3baec8c61b153ee"
