# This file is used to configure the AWS provider. In this example, we are configuring two AWS providers, one for the us-east-1 region and another for the ap-west-2 region.

provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  region = "ap-west-2"
  alias = "secondary"
}