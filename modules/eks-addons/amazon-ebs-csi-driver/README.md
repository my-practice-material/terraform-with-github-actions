
Chart: https://github.com/kubernetes-sigs/aws-ebs-csi-driver/

follow below link if you are using custom kms key

https://docs.aws.amazon.com/eks/latest/userguide/ebs-csi.html



eksctl create iamserviceaccount \
        --name ebs-csi-controller-sa \
        --namespace kube-system \
        --cluster study-eks-cluster \
        --role-name AmazonEKS_EBS_CSI_DriverRole \
        --role-only \
        --attach-policy-arn arn:aws:iam::aws:policy/AmazonEBSCSIDriverPolicyV2 \
        --approve \
        --profile admin
