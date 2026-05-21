# Amazon EFS CSI Driver Installation on EKS

This Terraform configuration installs the **Amazon EFS CSI Driver** in an Amazon EKS cluster using Helm. It provisions the required IAM role with an OIDC trust relationship, attaches the necessary policy, and configures the driver’s service account with the IAM role for IRSA (IAM Roles for Service Accounts).

---

## 📌 Features
- **IAM Role** for the EFS CSI Driver with trust relationship to the EKS OIDC provider.
- **Policy Attachment**: `AmazonEFSCSIDriverPolicy` attached to the IAM role.
- **Helm Release** to deploy the EFS CSI Driver into the `kube-system` namespace.
- **Service Account** (`efs-csi-controller-sa`) annotated with IAM role ARN for IRSA integration.

---

## ⚙️ Prerequisites
- An existing **EKS cluster**.
- OIDC provider enabled for the cluster.
- Terraform configured with AWS provider.
- Helm provider configured for Terraform.

---

## 📂 Resources Created
| **[IAM Role](ca://s?q=Explain_AWS_IAM_Role)** | Grants the EFS CSI Driver permissions to manage EFS volumes. |
|---------------------------------|------------------------------------------------|
| **[IAM Policy Attachment](ca://s?q=AmazonEFSCSIDriverPolicy)** | Attaches `AmazonEFSCSIDriverPolicy` to the IAM role. |
| **[Helm Release](ca://s?q=Helm_release_in_Terraform)** | Installs the EFS CSI Driver chart from the official repository. |
| **[Service Account](ca://s?q=EKS_Service_Account_with_IRSA)** | Annotated with IAM role ARN for IRSA integration. |

---

## Repositories
- **Repository:** https://github.com/kubernetes-sigs/aws-efs-csi-driver/tree/master/charts/aws-efs-csi-driver
- **Chart:** https://kubernetes-sigs.github.io/aws-efs-csi-driver

