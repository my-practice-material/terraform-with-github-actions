# 📘 AWS EKS Fargate Profile Overview
- **Definition:** An EKS Fargate Profile defines which Kubernetes pods run on AWS Fargate, a serverless compute engine for containers. It eliminates the need to manage EC2 worker nodes.

- **Key Benefit:** Provides on‑demand, right‑sized compute capacity for pods, improving scalability and reducing operational overhead.

---

## 🔑 Required IAM Role for Fargate Profile
### Pod Execution Role

- **Trust Policy:** Must allow the service principal `eks-fargate-pods.amazonaws.com` to assume the role.

- **Permissions Policy:** Attach the AWS‑managed policy `AmazonEKSFargatePodExecutionRolePolicy`.

- **Purpose:** Provides permissions for Fargate to run pods, including pulling images from Amazon ECR or other registries.

### Service-linked Role

- Automatically created by EKS when you set up Fargate.

- Named `AWSServiceRoleForAmazonEKSForFargate`.

- Allows EKS to manage VPC networking for Fargate pods (creating/deleting ENIs).

---

## 🎯 Pod Selection in Fargate Profile
### Namespace selector

- Every selector must include a namespace.

- All pods in that namespace (matching optional labels) will be scheduled onto Fargate.

### Label selector

- You can refine selection by specifying key/value labels.

- Only pods with matching labels in the given namespace will run on Fargate.

- If no labels are provided, all pods in the namespace are eligible.

### Multiple selectors

- A profile can contain multiple selectors.

- This allows you to target different namespaces or label sets with the same profile.