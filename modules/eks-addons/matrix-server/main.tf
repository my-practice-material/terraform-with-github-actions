resource "aws_eks_addon" "metrics_server" {
  cluster_name = var.cluster_name # Must match your EKS cluster name
  addon_name   = "metrics-server"    # Use "metrics-server" as the identifier
  
  # Optional: specify a version or use most recent
  addon_version               = var.matrix_server_version
  resolve_conflicts_on_create = "OVERWRITE"
}