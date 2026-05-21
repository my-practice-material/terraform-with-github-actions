# Amazon EBS CSI Driver Installation on EKS

This Terraform configuration installs the **Amazon EBS CSI Driver** in an Amazon EKS cluster using Helm. It provisions the required IAM role with an OIDC trust relationship, attaches the necessary policy, and configures the driver’s service account with the IAM role for IRSA (IAM Roles for Service Accounts).

---

## 📌 Features
- **IAM Role** for the EBS CSI Driver with trust relationship to the EKS OIDC provider.
- **Policy Attachment**: `AmazonEBSCSIDriverPolicyV2` attached to the IAM role.
- **Helm Release** to deploy the EBS CSI Driver into the `kube-system` namespace.
- **Service Account** (`ebs-csi-controller-sa`) annotated with IAM role ARN for IRSA integration.

---

## ⚙️ Prerequisites
- An existing **EKS cluster**.
- OIDC provider enabled for the cluster.
- Terraform configured with AWS provider.
- Helm provider configured for Terraform.

---

## 📂 Resources Created
| **[IAM Role](ca://s?q=Explain_AWS_IAM_Role)** | Grants the EBS CSI Driver permissions to manage EBS volumes. |
|---------------------------------|------------------------------------------------|
| **[IAM Policy Attachment](ca://s?q=AmazonEBSCSIDriverPolicyV2)** | Attaches `AmazonEBSCSIDriverPolicyV2` to the IAM role. |
| **[Helm Release](ca://s?q=Helm_release_in_Terraform)** | Installs the EBS CSI Driver chart from the official repository. |
| **[Service Account](ca://s?q=EKS_Service_Account_with_IRSA)** | Annotated with IAM role ARN for IRSA integration. |

---

## Repositories
- **Repository:** https://github.com/kubernetes-sigs/aws-ebs-csi-driver/tree/master/charts
- **Chart:** https://github.com/kubernetes-sigs/aws-ebs-csi-driver/
- Follow below link if you are using custom kms key: https://docs.aws.amazon.com/eks/latest/userguide/ebs-csi.html
