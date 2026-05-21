# AWS EKS Self-Managed Worker Nodes

This Terraform module provisions **self-managed worker nodes** for an Amazon EKS cluster. It creates the necessary IAM roles, security groups, launch templates, and an Auto Scaling Group via CloudFormation, and configures the `aws-auth` ConfigMap to allow nodes to join the cluster.

---

## 📌 Features
- **IAM Role & Policies** for worker nodes:
  - AmazonEKSWorkerNodePolicy
  - AmazonEKS_CNI_Policy
  - AmazonEC2ContainerRegistryReadOnly
  - AmazonSSMManagedInstanceCore
- **Instance Profile** to attach IAM role to EC2 nodes.
- **Security Group** rules for communication between:
  - Worker nodes
  - EKS control plane
- **Launch Template** for EC2 instances:
  - `t3.medium` instance type (default)
  - 30 GB gp3 root volume
  - Bootstrap script for EKS
- **Auto Scaling Group** created via CloudFormation for rolling updates.
- **aws-auth ConfigMap** to map IAM role to Kubernetes `system:nodes`.

---

## ⚙️ Prerequisites
- An existing **EKS cluster**.
- VPC and subnets configured.
- Existing EC2 key pair.
- Latest EKS-optimized AMI available via SSM.

---

## 📂 Resources Created
| **[IAM Role](ca://s?q=Explain_AWS_IAM_Role)** | Grants EC2 nodes permissions to interact with EKS and AWS services. |
|---------------------------------|------------------------------------------------|
| **[Instance Profile](ca://s?q=What_is_AWS_Instance_Profile)** | Associates IAM role with EC2 worker nodes. |
| **[Security Group](ca://s?q=AWS_Security_Group_for_EKS)** | Controls traffic between nodes and control plane. |
| **[Launch Template](ca://s?q=AWS_Launch_Template_in_EKS)** | Defines EC2 instance configuration for worker nodes. |
| **[CloudFormation Stack](ca://s?q=AWS_CloudFormation_AutoScalingGroup)** | Creates Auto Scaling Group with rolling update policy. |
| **[aws-auth ConfigMap](ca://s?q=EKS_aws_auth_ConfigMap)** | Maps IAM role to Kubernetes node identities. |

---

## 🚀 Usage
```hcl
module "create_self_managed_node_group_al2" {
    source = "./modules/eks-compute/self-managed-node-group-al2"
    vpc_id = module.create_vpc.vpc_id
    worker_node_name = var.worker_node_name
    private_subnet_ids = module.create_vpc.private_subnets
    public_subnet_ids = module.create_vpc.public_subnets
    cluster_security_group_id = module.create_eks_standard_cluster.cluster_security_group_id
    cluster_name = var.eks_cluster_name
    node_group_desired_capacity = var.node_group_desired_capacity
    node_group_max_size = var.node_group_max_size
    node_group_min_size = var.node_group_min_size
    depends_on = [ module.create_eks_standard_cluster, module.install_vpc_cni ]
}
