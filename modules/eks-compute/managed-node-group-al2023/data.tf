# Get current AWS account identity
data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

# Reference an existing EC2 key pair by name
data "aws_key_pair" "existing_key_pair" {
  key_name = "study-ec2-keypair"   # replace with your actual key pair name
}

# Get AMI ID for latest recommended Amazon Linux 2023 EKS optimized AMI for Kubernetes version 1.35
data "aws_ssm_parameter" "node_ami" {
  name = "/aws/service/eks/optimized-ami/1.35/amazon-linux-2023/x86_64/standard/recommended/image_id"
}