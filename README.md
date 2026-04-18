# GitHub Actions Terraform

GitHub Actions Workflow for Terraform Deployment with AWS S3 and DynamoDB backend.

## 🚀 Overview
This repository demonstrates how to:
- Use **Terraform** to provision infrastructure.
- Configure **AWS S3** as a remote backend to store `terraform.tfstate`.
- Configure **AWS DynamoDB** for state locking (or use `use_lockfile` in Terraform >= 1.9.0).
- **Note:** Since Terraform 1.9.0, you can use use_lockfile = true instead of DynamoDB for state locking.
- Automate deployments with **GitHub Actions**.

## ⚙️ Prerequisites
- AWS account with IAM permissions to create S3 and DynamoDB resources.
- Terraform CLI installed (>= 1.5.x recommended).
- AWS CLI installed and configured.
- GitHub repository secrets set:
  - `GutHub Actions AWS OIDC Role` 

## 📂 Terraform Modules


## 📚 Modules

| Module Name | Description | Documentation |
|-------------|-------------|----------------|
| VPC         | Creates VPC, Subnets, and Networking Resources | [modules/vpc/README.md](modules/vpc README.md) |
| EKS         | Provisions an EKS cluster | [modules/eks/README.md](modules/eks/README.md) |

---