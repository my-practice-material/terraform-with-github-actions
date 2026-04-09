# Terraform Variables for Dev Environment in US East 1 Region

bucket_name = "study-terraform-with-github-actions"
vpc_name = "study-vpc"
vpc_cidr = "10.0.0.0/16"
azs = ["us-east-1a", "us-east-1b"]
public_subnets = ["10.0.2.0/24", "10.0.3.0/24"]
public_subnet_names = ["study-vpc-pub-sbnt-az1", "study-vpc-pub-sbnt-az2"]
app_private_subnets = ["10.0.4.0/24", "10.0.5.0/24"]
app_private_subnet_names = ["study-vpc-app-priv-sbnt-az1", "study-vpc-app-priv-sbnt-az2"]
db_private_subnets = ["10.0.6.0/24", "10.0.7.0/24"]
db_private_subnet_names = ["study-vpc-db-priv-sbnt-az1", "study-vpc-db-priv-sbnt-az2"]