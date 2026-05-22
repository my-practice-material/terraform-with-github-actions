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

resource "aws_eks_access_entry" "github_actions_entry" {
  cluster_name = var.cluster_name
  principal_arn = aws_iam_role.github_actions_oidc.arn
  type          = "STANDARD"
  depends_on = [ aws_iam_role.github_actions_oidc ]
}

resource "aws_eks_access_policy_association" "github_actions_assoc" {
  cluster_name = var.cluster_name
  principal_arn = aws_iam_role.github_actions_oidc.arn
  policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  access_scope {
    type = "cluster"
  }
  depends_on = [ aws_iam_role.github_actions_oidc ]
}
