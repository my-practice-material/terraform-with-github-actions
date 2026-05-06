### 1. Self-managed Node Group - AL2
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