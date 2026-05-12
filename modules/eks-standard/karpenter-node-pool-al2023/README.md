apiVersion: karpenter.k8s.aws/v1
kind: EC2NodeClass
metadata:
  name: default
  namespace: karpenter
spec:
  amiFamily: AL2023
  amiSelectorTerms:
    - id: {{ .Values.amiID }}   # AMI ID for worker nodes
  role: {{ .Values.karpenterNodeRole}}   # IAM role for worker nodes
  blockDeviceMappings:
    - deviceName: /dev/xvda
      ebs:
        volumeSize: 20Gi
        volumeType: gp3
        deleteOnTermination: true
  subnetSelectorTerms:
    - tags:
        karpenter.sh/discovery: {{ .Values.clusterName }}
  securityGroupSelectorTerms:
    - tags:
        karpenter.sh/discovery: {{ .Values.clusterName }}
  userData: |
    MIME-Version: 1.0
    Content-Type: multipart/mixed; boundary="==BOUNDARY=="

    --==BOUNDARY==
    Content-Type: application/node.eks.aws

    ---
    apiVersion: node.eks.aws/v1.alpha1
    kind: NodeConfig
    spec:
      cluster:
        name: {{ .Values.clusterName }}
        apiServerEndpoint: {{ .Values.clusterEndpoint }}
        certificateAuthority: {{ .Values.clusterCA }}
        cidr: {{ .Values.clusterServiceCIDR }}
      containerd:
        config: |
          [plugins."io.containerd.grpc.v1.cri"]
          sandbox_image = "602401143452.dkr.ecr.{{ .Values.region }}.amazonaws.com/eks/pause:3.8"
      kubelet:
        config: |
          clusterDNS:
          - {{ .Values.clusterDNS }}
        flags:
          - --node-labels=karpenter.sh/capacity-type=on-demand,karpenter.sh/nodepool=default

      --==BOUNDARY==
      Content-Type: text/x-shellscript
      #!/bin/bash
      /usr/bin/nodeadm init

      systemctl restart containerd

      # wait for containerd to be ready
      for i in {1..30}; do
       if systemctl is-active --quiet containerd; then
         echo "containerd is active"
         break
       fi
        echo "Waiting for containerd to be active..."
        sleep 2
      done

      ctr --namespace k8s.io images pull --user AWS:$(aws ecr get-login-password --region {{ .Values.region }}) 602401143452.dkr.ecr.{{ .Values.region }}.amazonaws.com/eks/pause:3.8

      systemctl restart kubelet

    --==BOUNDARY==--

  tags:
    karpenter.sh/discovery: {{ .Values.clusterName }}
