# AWS EKS Standard Mode.

AWS EKS Standard Mode is the original way to run Kubernetes on AWS: AWS manages the control plane, but you are responsible for the worker nodes, networking, storage, and addons. This gives maximum flexibility but also requires more operational effort compared to Auto Mode.

## 🌐 Networking Considerations

Worker nodes must be able to connect to the **EKS control plane** and other AWS services (STS, ECR, S3). Depending on your subnet design, you have three options:

### 1. Private Subnets + VPC Endpoints
- Create **Interface Endpoints** for:
  - `com.amazonaws.<region>.eks`
  - `com.amazonaws.<region>.sts`
  - `com.amazonaws.<region>.ecr.api`
  - `com.amazonaws.<region>.ecr.dkr`
- Create a **Gateway Endpoint** for:
  - `com.amazonaws.<region>.s3`
- ✅ Secure and cost-efficient (no NAT Gateway charges).

### 2. Private Subnets + NAT Gateway
- Place a NAT Gateway in a public subnet.
- Private nodes route outbound traffic through the NAT.
- ✅ Simple to set up, but incurs NAT costs.

### 3. Public Subnets
- Launch worker nodes in public subnets with public IPs.
- Nodes connect to the control plane and AWS services directly via the Internet Gateway.
- ⚠️ Less secure, but works if you don’t want to manage NAT or endpoints.

---

## Do we need the control plane in public subnets❓
No.  
The **EKS control plane is always provisioned by AWS in managed VPCs** that you don’t control. You only decide whether your worker nodes run in private or public subnets.  
- If nodes are in **private subnets**, you need **VPC endpoints or a NAT Gateway**.  
- If nodes are in **public subnets**, they can connect directly to the control plane via the internet.  

---

## 📖 Usage Example

```hcl
module "create_eks" {
    source = "./modules/eks"
    cluster_name = var.cluster_name
    private_subnet_ids = module.create_vpc.private_subnets
    public_subnet_ids = module.create_vpc.public_subnets
}
```

## 📚 Terraform EKS Compute Options.

| Module Name | Description | Documentation |
|-------------|-------------|----------------|
| self-managed-node-group         | Creates EKS Self Managed Node Groups with Amazon Linux 2 (AL2). | [self-managed-node-group-al2](./eks-compute/self-managed-node-group-al2/README.md) |
| aws-managed-node-group         | Create EKS AWS Managed Node Groups with Amazon Linux 2023 (AL2023). | [managed-node-group-al2023](managed-node-group-al2023/README.md) |
| fargate-profile         | Create EKS Fargate Profile. | [fargate-profile](fargate-profile/README.md) |
| karpenter-controller         | Install Karpenter Controller - karpenter-crd and karpenter using Helm chart. | [karpenter-controller](karpenter-controller/README.md) |
| karpenter-node-group         | Create AWS Managed Node Group to install Karpenter controller resources. | [karpenter-node-group-al2023](karpenter-node-group-al2023/README.md) |
| karpenter-node-pool         | Create Karpenter NodeClass & NodePool. | [karpenter-node-pool-al2023](karpenter-node-pool-al2023/README.md) |
| aws-managed-node-group-bottlerocket         | Create EKS Managed Node Group with Amazon Bottlerocket. | [managed-node-group-bottlerocket](managed-node-group-bottlerocket/README.md) |
| cluster-autoscaler         | Install Cluster Autoscaler on EKS Cluster. | [cluster-autoscaler](cluster-autoscaler/README.md) |