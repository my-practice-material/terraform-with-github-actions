# Terraform AWS EKS Karpenter Node Pool Module

This module provisions a **Karpenter Node Pool** for Amazon EKS using Terraform.  
It creates the required IAM roles, instance profiles, security groups, launch template, and EKS node group resources to support Karpenter-managed workloads.

---

## 🌟 What is a Karpenter Node Pool?

- **[Karpenter](ca://s?q=AWS_Karpenter_overview)** is an open-source Kubernetes node lifecycle manager.  
- While the Karpenter controller handles dynamic scaling, a **Node Pool** provides the baseline worker nodes and configuration for workloads.  
- This module sets up the IAM and networking prerequisites so that Karpenter can provision and manage nodes efficiently.

---

## 🚀 Features
- **[IAM Role](ca://s?q=Terraform_EKS_node_instance_role)** for worker nodes with required policies:
  - `AmazonEKSWorkerNodePolicy`
  - `AmazonEKS_CNI_Policy`
  - `AmazonEC2ContainerRegistryReadOnly`
  - `AmazonSSMManagedInstanceCore`
- **[Instance Profile](ca://s?q=Terraform_EKS_instance_profile)** to associate IAM role with EC2 nodes.
- **[Security Group](ca://s?q=Terraform_EKS_node_security_group)** for node communication and control plane access.
- **[Ingress/Egress Rules](ca://s?q=Terraform_EKS_security_group_rules)** to allow:
  - Node-to-node communication
  - Control plane to node communication (ports 443, 1025–65535)
  - Node egress to internet
- **[Launch Template](ca://s?q=Terraform_EKS_launch_template)** with:
  - Custom AMI from SSM
  - Instance type (`t3.small` by default)
  - User data for kubelet/node initialization
  - Block device mapping (20 GB gp3 volume)
- **[EKS Node Group](ca://s?q=Terraform_EKS_node_group)** with:
  - Scaling configuration (min, max, desired size)
  - Taints for Karpenter scheduling
  - Subnet placement
- **[CoreDNS Addon](ca://s?q=Terraform_EKS_coredns_addon)** configured with tolerations and affinity for Karpenter nodes.

---

## 📂 Module Components
- `main.tf` → IAM roles, instance profile, security groups, launch template, node group, addons
- `variables.tf` → Input variables (cluster name, subnets, desired capacity, etc.)
- `outputs.tf` → Exported values (role ARN, node group name, security group ID)

---

## ⚙️ Usage Example

```hcl
module "create_karpenter_node_pool_al2023" {
   source                      = "./modules/eks-compute/karpenter-node-pool-al2023"
   cluster_name                = var.eks_cluster_name
   certificate_authority_data  = module.create_eks_standard_cluster.certificate_authority_data
   cluster_endpoint            = module.create_eks_standard_cluster.cluster_endpoint
   service_ipv4_cidr           = module.create_eks_standard_cluster.service_ipv4_cidr
   vpc_id                      = module.create_vpc.vpc_id
   cluster_security_group_id   = module.create_eks_standard_cluster.cluster_security_group_id
   karpenter_worker_node_name  = var.karpenter_worker_node_name
   karpenter_controller_node_name = var.karpenter_controller_node_name
   karpenter_node_role_arn     = module.create_karpenter_node_group_al2023.karpenter_node_group_iam_role_arn
   depends_on                  = [ module.deploy-karpenter-controller ]
}
