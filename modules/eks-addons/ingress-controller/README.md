1. Create IRSA role for Ingress Controller.
2. Need to Create Ingress Controller Policy with required permission. Required policy can be downloaded using command below.

curl -o iam-policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.4.7/docs/install/iam_policy.json  

3. Deploy Ingress Controller using helm remot repo or we can download Ingress Controller helm chart localy and deploy.

Please find below links for reference.

https://github.com/kubernetes-sigs/aws-load-balancer-controller/tree/main/helm/aws-load-balancer-controller

https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.4/deploy/installation/


