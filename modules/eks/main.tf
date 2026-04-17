resource "aws_eks_cluster" "study-eks-cluster" {
  name = var.cluster_name

  access_config {
    authentication_mode = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true
  }

  role_arn = aws_iam_role.study-eks-cluster-role.arn
  version  = "1.35"

  vpc_config {
    subnet_ids = var.public_subnet_ids
    endpoint_private_access = true
    endpoint_public_access  = true
  }

  upgrade_policy {
    support_type = "STANDARD"
  }
  # Ensure that IAM Role permissions are created before and deleted
  # after EKS Cluster handling. Otherwise, EKS will not be able to
  # properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
  ]

  tags = var.tags
}

resource "aws_iam_role" "study-eks-cluster-role" {
  name = "study-eks-cluster-role"
  tags = var.tags
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.study-eks-cluster-role.name
}

resource "aws_eks_access_entry" "admin" {
  cluster_name = aws_eks_cluster.study-eks-cluster.name
  principal_arn = var.cluster_admin_role_arn
  type = "STANDARD"
}

resource "aws_eks_access_policy_association" "admin" {
  cluster_name = aws_eks_cluster.study-eks-cluster.name
  principal_arn = var.cluster_admin_role_arn
  policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  access_scope {
    type = "Cluster"
  }
}

