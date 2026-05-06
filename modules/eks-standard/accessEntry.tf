# resource "aws_eks_access_entry" "admin" {
#   cluster_name = aws_eks_cluster.study-eks-cluster.name
#   principal_arn = var.cluster_admin_role_arn
#   type = "STANDARD"
# }

resource "aws_eks_access_policy_association" "admin" {
  cluster_name = aws_eks_cluster.study-eks-cluster.name
  principal_arn = var.cluster_admin_role_arn
  policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  access_scope {
    type = "cluster"
  }
}
