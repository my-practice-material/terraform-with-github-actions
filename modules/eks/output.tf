output "cluster_security_group_id" {
  value = aws_eks_cluster.study-eks-cluster.vpc_config[0].cluster_security_group_id
  description = "ID of the security group associated with the EKS cluster"
}