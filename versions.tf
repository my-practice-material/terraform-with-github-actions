# This file is used to specify the required Terraform version and the required providers for the Terraform configuration. 
# In this example, we are specifying that we require Terraform version 1.10.0 or higher and the AWS provider version 6.0 or higher.
terraform {
    required_version = ">= 1.10.0"
    required_providers {
        aws = {
        source  = "hashicorp/aws"
        version = "~> 6.0"
        }
    }
}