# AWS EKS Auto Mode - Bottlerocket

AWS EKS Auto Mode is a fully managed Kubernetes option where AWS not only runs the control plane but also provisions, scales, secures, and updates the worker nodes and critical cluster infrastructure (like CoreDNS, kube‑proxy, VPC CNI, load balancing, and storage). It delivers a production‑ready cluster with minimal operational overhead, letting you focus entirely on workloads. 

## 🚀 Overview
- Zero infrastructure management — AWS handles node provisioning, scaling, and lifecycle.
- Simplifies cluster operations significantly.
- Ideal for teams that want to focus purely on workloads without managing nodes.

- Less flexibility in choosing instance types or customizing node configurations.
- May not support specialized workloads (e.g., GPUs, custom AMIs).

- Currently limited to certain regions and features.
- Bound to AWS’s supported configurations; advanced customization is not available.

---

## 📚 EKS Auto Mode vs Standard Mode – Comparison Snapshot

| Component            | Standard Mode (You manage) | Auto Mode (AWS manages) |
|----------------------|-----------------------------|--------------------------|
| CoreDNS              | Install/upgrade manually    | Pre‑installed, auto‑updated |
| kube‑proxy           | Install/upgrade manually    | Pre‑installed, auto‑updated |
| VPC CNI              | Install/upgrade manually    | Pre‑installed, auto‑updated |
| Node autoscaling     | Cluster Autoscaler/Karpenter | Karpenter (built‑in) |
| Load Balancing       | Install ALB Controller      | Managed by AWS |
| Storage (EBS)        | Configure via CSI driver    | Auto‑provisioned |
| GPU Support          | Manual AMI setup            | Auto‑provisioned |
