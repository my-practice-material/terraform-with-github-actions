# Terraform EKS Compute Options Module

This module provides multiple compute options for running workloads on Amazon EKS. It is designed to be flexible so you can choose the right node type for your cluster depending on your use case.

## 🚀 Supported Compute Options

### 1. Self-managed Node Group
EC2 Auto Scaling Group managed by Terraform.

**Pros**
- Full control over AMI, bootstrap scripts, and scaling policies.
- Can customize OS, networking, and security settings.
- Useful for advanced scenarios (custom kernels, GPU drivers, etc.).

**Cons**
- You manage lifecycle (updates, draining, scaling).
- More operational overhead compared to managed node groups.

**Limitations**
- Requires careful maintenance of AMIs and bootstrap scripts.
- No automatic upgrades from EKS.

---

### 2. AWS-managed Node Group
Native EKS managed node groups.

**Pros**
- Simplified lifecycle management (updates, scaling, draining handled by EKS).
- Integrated with EKS console and APIs.
- Easier to operate for most workloads.

**Cons**
- Less flexibility (limited AMI customization).
- Some advanced configurations not supported.

**Limitations**
- Bound to AWS’s supported AMIs and upgrade process.
- Cannot fully control bootstrap sequence.

---

### 3. Fargate
Serverless compute for pods.

**Pros**
- No EC2 nodes to manage.
- Pay only for pod resources.
- Ideal for small workloads, jobs, or environments where you don’t want to manage nodes.

**Cons**
- Limited pod configuration (no DaemonSets, not supporting EBS & EFS, privileged pods).
- Higher cost for long-running workloads compared to EC2.

**Limitations**
- Not suitable for workloads needing GPUs, custom networking, or host-level access.
- Only supports certain namespaces and pod specs.

---

### 4. Karpenter
Open-source node provisioning solution.

**Pros**
- Fast, flexible, and cost-efficient scaling.
- Can launch diverse instance types based on workload demand.
- Reduces over-provisioning and idle capacity.

**Cons**
- Requires additional setup and controller management.
- Still evolving; may need tuning for stability.

**Limitations**
- Needs IAM roles and permissions configured correctly.
- Not a fully managed AWS service (community-driven).

---

### 5. AWS EKS Auto Mode
A fully managed compute option where AWS automatically provisions and manages nodes for your cluster.

**Pros**
- Zero infrastructure management — AWS handles node provisioning, scaling, and lifecycle.
- Simplifies cluster operations significantly.
- Ideal for teams that want to focus purely on workloads without managing nodes.

**Cons**
- Less flexibility in choosing instance types or customizing node configurations.
- May not support specialized workloads (e.g., GPUs, custom AMIs).

**Limitations**
- Currently limited to certain regions and features.
- Bound to AWS’s supported configurations; advanced customization is not 

---

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

## ❓ Do we need the control plane in public subnets?
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

module "eks_self_managed_node_group" {
    source = "./modules/eks/self-managed-node-group"
    vpc_id = module.create_vpc.vpc_id
    public_subnet_ids = module.create_vpc.public_subnets
    cluster_security_group_id = module.create_eks.cluster_security_group_id
    cluster_name = var.cluster_name
    node_group_desired_capacity = var.node_group_desired_capacity
    node_group_max_size = var.node_group_max_size
    node_group_min_size = var.node_group_min_size
}