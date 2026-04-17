output "cluster_security_group_id" {
  value = aws_eks_cluster.study-eks-cluster.vpc_config[0].cluster_security_group_id
  description = "ID of the security group associated with the EKS cluster"
}

output "cluster_endpoint" {
  value = aws_eks_cluster.study-eks-cluster.endpoint
  description = "Endpoint URL for the EKS cluster API server"
}

output "cluster_certificate_authority_data" {
  value = aws_eks_cluster.study-eks-cluster.certificate_authority[0].data
  description = "Base64 encoded certificate authority data for the EKS cluster"
}

output "cluster_name" {
  value = aws_eks_cluster.study-eks-cluster.name
  description = "Name of the EKS cluster"
}