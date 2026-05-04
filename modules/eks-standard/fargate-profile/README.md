### Fargate-Profile.
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