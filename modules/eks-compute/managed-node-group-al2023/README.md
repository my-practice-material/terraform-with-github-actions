### AWS-managed Node Group - AL2023
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