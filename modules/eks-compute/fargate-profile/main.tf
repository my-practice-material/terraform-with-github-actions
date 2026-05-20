resource "aws_iam_role" "eks-fargate-profile-role" {
  name = "eks-fargate-profile-role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks-fargate-pods.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "study-eks-fargate-profile-role-attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role       = aws_iam_role.eks-fargate-profile-role.name
}

resource "aws_eks_fargate_profile" "kube-dns-fargate-profile" {
  cluster_name           = var.cluster_name
  fargate_profile_name   = "kube-dns-fargate-profile"
  pod_execution_role_arn = aws_iam_role.eks-fargate-profile-role.arn
  subnet_ids             = [
    var.private_subnet_ids[0], # us-east-1a
    var.private_subnet_ids[1], # us-east-1b
  ]
  # core-dns does not by default run on fargate, so we need to add a selector and label for it to run on fargate
  selector {
    namespace = "kube-system"
    labels = {
      k8s-app = "kube-dns"
    }
  }
}

resource "aws_eks_fargate_profile" "study-fargate-profile" {
  cluster_name           = var.cluster_name
  fargate_profile_name   = "study-fargate-profile"
  pod_execution_role_arn = aws_iam_role.eks-fargate-profile-role.arn
  subnet_ids             = [
    var.private_subnet_ids[0], # us-east-1a
    var.private_subnet_ids[1], # us-east-1b
  ]
  # Allow all pods in kube-system namespace
  selector {
    namespace = "kube-system"
  }
}