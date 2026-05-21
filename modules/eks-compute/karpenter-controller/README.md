# Terraform AWS EKS Karpenter Controller Module

This module deploys the **Karpenter Controller** into an Amazon EKS cluster using Terraform and Helm.  
It provisions the required IAM role, service account, IAM policies, and installs the Karpenter CRDs and controller via Helm charts.

---

## 🌟 What is Karpenter?

- **[Karpenter](ca://s?q=AWS_Karpenter_overview)** is an open-source node lifecycle management solution for Kubernetes.  
- It automatically launches right-sized EC2 instances in response to pending pods, improving efficiency and reducing costs.  
- Unlike the **[Cluster Autoscaler](ca://s?q=Cluster_Autoscaler_vs_Karpenter)**, which scales node groups, Karpenter works directly with EC2 APIs, enabling:
  - Faster scaling decisions
  - Flexible instance types (including Spot)
  - More efficient bin-packing of pods
  - Reduced operational overhead

---

## 🚀 Benefits Compared to Cluster Autoscaler
- **[Speed](ca://s?q=Karpenter_scaling_speed)**: Reacts to unschedulable pods in seconds, not minutes.  
- **[Flexibility](ca://s?q=Karpenter_instance_flexibility)**: Chooses from any EC2 instance type, not limited to pre-defined node groups.  
- **[Efficiency](ca://s?q=Karpenter_cost_efficiency)**: Optimizes pod placement to minimize waste.  
- **[Simplicity](ca://s?q=Karpenter_simpler_than_cluster_autoscaler)**: No need to manage multiple ASGs or node groups.

---

## 📂 Module Components

- **IAM OIDC Provider** for EKS cluster identity.  
- **IAM Role** for Karpenter controller with OIDC trust relationship.  
- **IAM Policy** attached to the role (`karpenter-controller-policy.json`).  
- **Service Account** (`karpenter-sa`) annotated with IAM role ARN.  
- **Helm Release** for Karpenter CRDs.  
- **Helm Release** for Karpenter controller (depends on CRDs).  
- **Sleep Resource** to ensure CRDs are ready before controller installation.

---

## 📦 Chart References

- **GitHub Repository**: [aws/karpenter-provider-aws – charts](https://github.com/aws/karpenter-provider-aws/tree/main/charts)  
- **OCI Registry**:  
  - `repository = "oci://public.ecr.aws/karpenter"`  
    - `chart = "karpenter-crd"`  
    - `chart = "karpenter"`

---
## ⚙️ Usage Example

```hcl
module "deploy-karpenter-controller" {
   source = "./modules/eks-compute/karpenter-controller"
   cluster_name = var.eks_cluster_name
   aws_iam_openid_connect_provider_arn = module.create_eks_standard_cluster.aws_iam_openid_connect_provider_arn
   tags = var.tags
   depends_on = [ module.create_eks_standard_cluster, module.create_karpenter_node_group_al2023 ]
 }