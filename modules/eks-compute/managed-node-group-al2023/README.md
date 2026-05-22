# Terraform AWS EKS Managed Node Group Module (AL2023 AMI)

This module provisions a **Managed Node Group** in Amazon EKS using Terraform.  
It creates the required IAM roles, instance profile, security groups, launch template, and node group resources with **Amazon Linux 2023 (AL2023) AMI**.

---

## 🌟 Overview

- **[Managed Node Group](ca://s?q=AWS_EKS_managed_node_group_overview)**: Simplifies worker node lifecycle management by letting EKS handle provisioning and updates.  
- **[Amazon Linux 2023 AMI](ca://s?q=Amazon_Linux_2023_AMI_for_EKS)**: Provides a secure, optimized, and modern OS for Kubernetes workloads.  
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
  - AL2023 AMI from SSM Parameter Store
  - Instance type (`t3.small` by default)
  - User data for kubelet/node initialization
  - Block device mapping (20 GB gp3 volume)
- **Managed Node Group** with:
  - Scaling configuration (min, max, desired size)
  - Subnet placement
  - Update configuration (rolling updates)

---

## 📂 Important Note

- `KMS`: If EC2 having encryption using custom kms key then we need to add `AWSServiceRoleForAutoScaling` and node IAM role into policy to allow below actions.
  "Action": [
    "kms:Encrypt",
    "kms:Decrypt",
    "kms:GenerateDataKey*",
    "kms:DescribeKey"
  ],

---

## ⚙️ Usage Example

```hcl
module "create_managed_node_group_al2023" {
    source = "./modules/eks-compute/managed-node-group-al2023"
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
