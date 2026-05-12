# Kubernetes Cluster Autoscaler

Cluster Autoscaler automatically adjusts the size of a Kubernetes cluster so that:
- All pods have a place to run.
- Unneeded nodes are removed safely.
- It supports multiple cloud providers, including AWS.

**GitHub:** https://github.com/kubernetes/autoscaler

---

## 🚀 Steps to Deploy Cluster Autoscaler on AWS EKS

### 1. Create IRSA Role
Create an IAM role with the required permissions for Cluster Autoscaler:
- "autoscaling:DescribeAutoScalingGroups",
- "autoscaling:DescribeAutoScalingInstances",
- "autoscaling:DescribeLaunchConfigurations",
- "autoscaling:DescribeScalingActivities",
- "autoscaling:SetDesiredCapacity",
- "autoscaling:TerminateInstanceInAutoScalingGroup"
- "ec2:DescribeImages",
- "ec2:DescribeInstanceTypes",
- "ec2:DescribeLaunchTemplateVersions",
- "ec2:GetInstanceTypesFromInstanceRequirements",
- "eks:DescribeNodegroup"

### 2. Deploye Cluster Autoscaler Helm chart.

##### 1. Deploy Using Local Helm Chart (Air‑gapped / Private Environment):
If your environment does not have internet access, download the Cluster Autoscaler Helm chart locally and deploy it.

##### 2. Deploy Using Remote Helm Chart (Recommended):
For internet‑connected environments, deploy directly from the official Helm repository:

```hcl
resource "helm_release" "cluster_autoscaler" {
  name       = "cluster-autoscaler"
  namespace  = "kube-system"

  # Remote chart from official autoscaler repo
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  version    = "9.29.0" # pin to a tested version

  # Values configuration
  values = [
    yamlencode({
    })
  ]
}
