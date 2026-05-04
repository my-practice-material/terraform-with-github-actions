# Get current AWS account identity
data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

# Reference an existing EC2 key pair by name
data "aws_key_pair" "existing_key_pair" {
  key_name = "study-ec2-keypair"   # replace with your actual key pair name
}

# Bottlerocket AMI for EKS 1.35 (x86_64)
data "aws_ssm_parameter" "node_ami" {
  name = "/aws/service/bottlerocket/aws-k8s-1.35/x86_64/latest/image_id"
}