For EFS Storage Class First we need EFS filesystemID
So we need to create EFS File system first.


1. Network / Security Group Rules
Inbound rule on EFS mount target SG:

Allow TCP 2049 (NFS) from the security group of your worker nodes.

Outbound rule on node SG:

Allow traffic to TCP 2049 so nodes can initiate NFS connections.

DNS resolution:

VPC must have DNS hostnames and DNS resolution enabled.

Nodes must be able to resolve fs-<id>.efs.<region>.amazonaws.com.

2. IAM Permissions for Worker Node Role
Attach the managed policy AmazonElasticFileSystemClientReadWriteAccess to your worker node IAM role. This grants:

elasticfilesystem:DescribeMountTargets

elasticfilesystem:DescribeAccessPoints

elasticfilesystem:DescribeFileSystems

elasticfilesystem:ClientMount

elasticfilesystem:ClientWrite