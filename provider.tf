# This file is used to configure the AWS provider. In this example, we are configuring two AWS providers, one for the us-east-1 region and another for the ap-west-2 region.

provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  region = "ap-west-2"
  alias = "secondary"
}

provider "kubernetes" {
  host                   = module.create_eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.create_eks.certificate_authority[0].data)
  
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", module.create_eks.cluster_name, "--region", data.aws_region.current]
  }
}