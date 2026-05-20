# Terraform AWS EKS Cluster Autoscaler Module

This module deploys the **Cluster Autoscaler** into an Amazon EKS cluster using Terraform and Helm.  
It provisions the required IAM role, IAM policy, service account, and installs the Cluster Autoscaler Helm chart.

---

## 🌟 What is Cluster Autoscaler?

- **[Cluster Autoscaler](ca://s?q=AWS_EKS_Cluster_Autoscaler_overview)** is a Kubernetes component that automatically adjusts the size of a cluster based on pending pods and resource utilization.  
- It scales node groups up when pods cannot be scheduled and scales down when nodes are underutilized.  
- This ensures efficient use of resources and cost optimization.

---

## 🚀 Features
- **[IAM Role](ca://s?q=Terraform_EKS_Cluster_Autoscaler_IAM_role)** with OIDC trust relationship for service account `cluster-autoscaler` in `kube-system` namespace.  
- **[IAM Policy](ca://s?q=Terraform_EKS_Cluster_Autoscaler_policy)** granting permissions for scaling node groups (defined in `iam-policy/cluster-autoscaler-policy.json`).  
- **[Service Account](ca://s?q=Terraform_EKS_service_account_with_IAM_role)** annotated with IAM role ARN.  
- **[Helm Release](ca://s?q=Terraform_EKS_Cluster_Autoscaler_Helm_chart)** to install Cluster Autoscaler into the cluster.  
- Supports **auto-discovery** of node groups via tags.

---

## 📦 Chart References

- **GitHub Repository**: [kubernetes/autoscaler – cluster-autoscaler](https://github.com/kubernetes/autoscaler/tree/master/cluster-autoscaler)  
- **Helm Chart Repository**: [Cluster Autoscaler Helm Chart](https://kubernetes.github.io/autoscaler)
  - `chart` = `cluster-autoscaler`

> In this module, the chart is downloaded locally (`${path.module}/helm`), but you can also reference the upstream chart repository.

---

## ⚙️ Usage Example

```hcl
module "deploy_cluster_autoscaler" {
  source = "./modules/eks-compute/kubernetes-cluster-autoscaler"
  cluster_name = var.eks_cluster_name
  aws_iam_openid_connect_provider_arn = module.create_eks_standard_cluster.aws_iam_openid_connect_provider_arn
  tags = var.tags
  depends_on = [ module.create_managed_node_group_al2023 ]
}
