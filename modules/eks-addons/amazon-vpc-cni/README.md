1. Need to create IRSA `system:serviceaccount:kube-system:aws-node`
2. Need to attach this `arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy` policy to IRSA role.
3. Create resource Amazon VPC CNI. Pass cluster name, IRSA role, Addon name and Addon version.
