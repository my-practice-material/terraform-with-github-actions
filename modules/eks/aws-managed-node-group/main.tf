data "aws_iam_policy_document" "assume_role_ec2" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

# IAM role to assign to worker nodes
resource "aws_iam_role" "node_instance_role" {
  name               = "${var.worker_node_name}-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_ec2.json
  path               = "/"
}

resource "aws_iam_role_policy_attachment" "node_instance_role_EKSWNP" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node_instance_role.name
}

resource "aws_iam_role_policy_attachment" "node_instance_role_EKSCNIP" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node_instance_role.name
}

resource "aws_iam_role_policy_attachment" "node_instance_role_EKSCRRO" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node_instance_role.name
}

resource "aws_iam_role_policy_attachment" "node_instance_role_SSMMIC" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.node_instance_role.name
}

# Instance profile to associate above role with worker nodes
resource "aws_iam_instance_profile" "node_instance_profile" {
  name = "NodeInstanceProfile"
  path = "/"
  role = aws_iam_role.node_instance_role.id
}

# Security group to apply to worker nodes
resource "aws_security_group" "node_security_group" {
  name        = "${var.worker_node_name}-security-group"
  description = "Security group for all nodes in the cluster"
  vpc_id      = var.vpc_id
  tags = {
    "Name" = "${var.worker_node_name}-security-group"
  }
}

#
# Now follows several rules that are applied to the node security group
# to allow control plane to access nodes
#

resource "aws_vpc_security_group_ingress_rule" "node_security_group_ingress" {
  description                  = "Allow node to communicate with each other"
  ip_protocol                  = "-1"
  referenced_security_group_id = aws_security_group.node_security_group.id
  security_group_id            = aws_security_group.node_security_group.id
}

resource "aws_vpc_security_group_ingress_rule" "node_security_group_from_control_plane_ingress" {
  description                  = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  security_group_id            = aws_security_group.node_security_group.id
  referenced_security_group_id = var.cluster_security_group_id
  from_port                    = 1025
  to_port                      = 65535
  ip_protocol                  = "TCP"
}

resource "aws_vpc_security_group_ingress_rule" "control_plane_egress_to_node_security_group_on_443" {
  description                  = "Allow pods running extension API servers on port 443 to receive communication from cluster control plane"
  security_group_id            = aws_security_group.node_security_group.id
  referenced_security_group_id = var.cluster_security_group_id
  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "TCP"
}

# CloudFormation defaults to egress all. Terraform does not.
resource "aws_vpc_security_group_egress_rule" "node_egress_all" {
  description       = "Allow node egress to anywhere"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
  security_group_id = aws_security_group.node_security_group.id
}

#
# Now follows several rules that are applied to the EKS cluster security group
# to allow nodes to access control plane
#

resource "aws_vpc_security_group_ingress_rule" "cluster_control_plane_security_group_ingress" {
  description                  = "Allow pods to communicate with the cluster API Server"
  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "TCP"
  security_group_id            = var.cluster_security_group_id
  referenced_security_group_id = aws_security_group.node_security_group.id
}

resource "aws_launch_template" "eks_node_group_launch_template" {
  name = "${var.worker_node_name}-launch-template"
  block_device_mappings {
    device_name = "/dev/xvda"
      ebs {
        volume_size = 20
        volume_type = "gp3"
        delete_on_termination = true
      }
  }
  image_id = data.aws_ssm_parameter.node_ami.value
  instance_type = "t3.small"
  key_name = data.aws_key_pair.existing_key_pair.key_name
  vpc_security_group_ids = [
    aws_security_group.node_security_group.id
  ]

user_data = base64encode(<<-EOF
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="==MYBOUNDARY=="

--==MYBOUNDARY==
Content-Type: application/node.eks.aws

---
apiVersion: node.eks.aws/v1alpha1
kind: NodeConfig
spec:
  cluster:
    name: ${var.cluster_name}
    apiServerEndpoint: ${var.cluster_endpoint}
    certificateAuthority: ${var.certificate_authority_data}
    cidr: ${var.service_ipv4_cidr}
  kubelet:
    config:
      clusterDNS:
        - ${cidrhost(var.service_ipv4_cidr, 10)}
    flags:
    - --node-labels=karpenter.sh/controller=true

--==MYBOUNDARY==
Content-Type: text/x-shellscript

#!/bin/bash
/usr/bin/nodeadm init

if systemctl list-unit-files | grep -q '^firewalld'; then
  systemctl stop firewalld
  systemctl disable firewalld
fi

systemctl restart containerd
systemctl restart kubelet

--==MYBOUNDARY==--
EOF
)

  tags = var.tags
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = var.worker_node_name
    }
  }
}

resource "aws_eks_node_group" "name" {
  cluster_name    = var.cluster_name
  node_group_name = var.worker_node_name
  launch_template {
    id      = aws_launch_template.eks_node_group_launch_template.id
    version = "$Latest"
  }
  node_role_arn   = aws_iam_role.node_instance_role.arn
  subnet_ids      = var.public_subnet_ids

  scaling_config {
    desired_size = var.node_group_desired_capacity
    max_size     = var.node_group_max_size
    min_size     = var.node_group_min_size
  }
}