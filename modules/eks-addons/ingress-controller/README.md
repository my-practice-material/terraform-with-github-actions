# AWS Load Balancer Controller (Ingress Controller) Installation on EKS

This Terraform configuration installs the **AWS Load Balancer Controller** (Ingress Controller) in an Amazon EKS cluster using Helm. It provisions the required IAM role with an OIDC trust relationship, attaches a custom IAM policy, and configures the controller’s service account with the IAM role for IRSA (IAM Roles for Service Accounts).

---

## 📌 Features
- **IAM Role** for the Ingress Controller with trust relationship to the EKS OIDC provider.
- **Custom IAM Policy** loaded from `iam-policy/ingress-controller-policy.json`.
- **Policy Attachment** to bind the IAM role and policy.
- **Helm Release** to deploy the AWS Load Balancer Controller into the `kube-system` namespace.
- **Service Account** (`ingress-controller-sa`) annotated with IAM role ARN for IRSA integration.

---

## ⚙️ Prerequisites
- An existing **EKS cluster**.
- OIDC provider enabled for the cluster.
- Terraform configured with AWS provider.
- Helm provider configured for Terraform.
- Custom IAM policy JSON file (`iam-policy/ingress-controller-policy.json`) defining required permissions.

---

## 📂 Resources Created
| **[IAM Role](ca://s?q=Explain_AWS_IAM_Role)** | Grants the Ingress Controller permissions to manage AWS load balancers. |
|---------------------------------|------------------------------------------------|
| **[IAM Policy](ca://s?q=AWS_IAM_Policy_for_Ingress_Controller)** | Custom policy defining permissions for the controller. |
| **[IAM Policy Attachment](ca://s?q=Attach_IAM_Policy_to_Role)** | Binds the IAM role with the custom policy. |
| **[Helm Release](ca://s?q=Helm_release_in_Terraform)** | Installs the AWS Load Balancer Controller chart from the official repository. |
| **[Service Account](ca://s?q=EKS_Service_Account_with_IRSA)** | Annotated with IAM role ARN for IRSA integration. |

---

## Repositories
- **repository =** https://github.com/kubernetes/ingress-nginx
- **chart repository =** "https://aws.github.io/eks-charts"
- **chart      =** "aws-load-balancer-controller"

---

Need to Create Ingress Controller Policy with required permission. Required policy can be downloaded using command below.

curl -o iam-policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.4.7/docs/install/iam_policy.json  

Ref: https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.4/deploy/installation/