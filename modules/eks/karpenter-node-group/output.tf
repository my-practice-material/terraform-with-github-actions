output "karpenter_node_group_iam_role_arn" {
  value = aws_iam_role.node_instance_role.arn
}