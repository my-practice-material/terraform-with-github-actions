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


# Launch Template defines how the autoscaling group will create worker nodes.
resource "aws_launch_template" "node_launch_template" {
  name = "${var.worker_node_name}-launch-template"
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      delete_on_termination = true
      volume_size           = 30
      volume_type           = "gp3"
    }
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.node_instance_profile.name
  }

  key_name      = data.aws_key_pair.existing_key_pair.key_name
  instance_type = "t3.medium"
  vpc_security_group_ids = [
    aws_security_group.node_security_group.id
  ]

  tags = var.tags

  image_id = data.aws_ssm_parameter.node_ami.value

  metadata_options {
    http_put_response_hop_limit = 2
    http_endpoint               = "enabled"
    http_tokens                 = "optional"
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = var.worker_node_name
    }
  }

  user_data = base64encode(<<EOF
    #!/bin/bash
    set -o xtrace
    /etc/eks/bootstrap.sh ${var.cluster_name}
    /opt/aws/bin/cfn-signal --exit-code $? \
                --stack  ${var.cluster_name}-stack \
                --resource NodeGroup  \
                --region us-east-1
    EOF
  )
}

# Wait for LT to settle, or CloudFormation may fail
resource "time_sleep" "wait_30_seconds" {
  depends_on = [
    aws_launch_template.node_launch_template
  ]

  create_duration = "30s"
}

# Defer to CloudFormation here to create AutoScalingGroup
# as the terraform ASG resource does not support UpdatePolicy
resource "aws_cloudformation_stack" "autoscaling_group" {
  depends_on = [
    time_sleep.wait_30_seconds
  ]
  name          = "eks-cluster-stack"
  template_body = <<EOF
Description: "Node autoscaler"
Resources:
  NodeGroup:
    Type: AWS::AutoScaling::AutoScalingGroup
    Properties:
      VPCZoneIdentifier: ["${var.public_subnet_ids[0]}","${var.public_subnet_ids[1]}"]
      MinSize: "${var.node_group_min_size}"
      MaxSize: "${var.node_group_max_size}"
      DesiredCapacity: "${var.node_group_desired_capacity}"
      HealthCheckType: EC2
      LaunchTemplate:
        LaunchTemplateId: "${aws_launch_template.node_launch_template.id}"
        Version: "${aws_launch_template.node_launch_template.latest_version}"
    UpdatePolicy:
    # Ignore differences in group size properties caused by scheduled actions
      AutoScalingScheduledAction:
        IgnoreUnmodifiedGroupSizeProperties: true
      AutoScalingRollingUpdate:
        MaxBatchSize: 1
        MinInstancesInService: "${var.node_group_desired_capacity}"
        PauseTime: PT5M
Outputs:
  NodeAutoScalingGroup:
    Description: The autoscaling group
    Value: !Ref NodeGroup
  EOF
}


resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = yamlencode([
      {
        rolearn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.worker_node_name}-role"
        username = "system:node:{{EC2PrivateDNSName}}"
        groups   = [
          "system:bootstrappers",
          "system:nodes"
        ]
      }
    ])
  }
}
