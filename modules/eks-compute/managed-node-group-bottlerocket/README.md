# Terraform AWS EKS Managed Node Group Module (Bottlerocket OS)

This module provisions a **Managed Node Group** in Amazon EKS using Terraform.  
It creates the required IAM roles, instance profile, security groups, launch template, and node group resources with **Bottlerocket OS**.

---

## 🌟 Overview

- **[Managed Node Group](ca://s?q=AWS_EKS_managed_node_group_overview)**: Simplifies worker node lifecycle management by letting EKS handle provisioning and updates.  
- **[Bottlerocket OS](ca://s?q=AWS_Bottlerocket_OS_for_EKS)**: A secure, minimal, container‑optimized operating system built by AWS, designed specifically for running Kubernetes workloads.  
- **[Terraform Module](ca://s?q=Terraform_EKS_managed_node_group_module)**: Automates IAM, networking, and launch template setup for consistent deployments.

---

## 🚀 Features

- **IAM Role** for worker nodes with attached policies:
  - `AmazonEKSWorkerNodePolicy`
  - `AmazonEKS_CNI_Policy`
  - `AmazonEC2ContainerRegistryReadOnly`
  - `AmazonSSMManagedInstanceCore`
- **Instance Profile** to associate IAM role with EC2 nodes.  
- **Security Group** for node communication and control plane access.  
- **Ingress/Egress Rules** to allow:
  - Node-to-node communication
  - Control plane to node communication (ports 443, 1025–65535)
  - Node egress to internet
- **Launch Template** with:
  - Bottlerocket AMI from SSM Parameter Store
  - Instance type (`t3.small` by default)
  - User data in **TOML format** for Bottlerocket configuration
  - Block device mapping (20 GB gp3 volume)
- **Managed Node Group** with:
  - Scaling configuration (min, max, desired size)
  - Subnet placement
  - Update configuration (rolling updates)

---

## 📂 Module Components

- `main.tf` → IAM roles, instance profile, security groups, launch template, node group  
- `variables.tf` → Input variables (cluster name, subnets, desired capacity, etc.)  
- `outputs.tf` → Exported values (role ARN, node group name, security group ID)

---

## ⚙️ Usage Example

```hcl
module "create_managed_node_group-bottlerocket" {
    source = "./modules/eks-compute/managed-node-group-bottlerocket"
    vpc_id = module.create_vpc.vpc_id
    worker_node_name = var.worker_node_name
    private_subnet_ids = module.create_vpc.private_subnets
    public_subnet_ids = module.create_vpc.public_subnets
    cluster_security_group_id = module.create_eks_standard_cluster.cluster_security_group_id
    cluster_name = var.eks_cluster_name
    node_group_desired_capacity = var.node_group_desired_capacity
    node_group_max_size = var.node_group_max_size
    node_group_min_size = var.node_group_min_size
    certificate_authority_data = module.create_eks_standard_cluster.certificate_authority_data
    cluster_endpoint = module.create_eks_standard_cluster.cluster_endpoint
    service_ipv4_cidr = module.create_eks_standard_cluster.service_ipv4_cidr
    depends_on = [ module.create_eks_standard_cluster, module.install_vpc_cni ]
}
