# This file is used to configure the Terraform backend. In this example, we are using S3 as the backend for storing the Terraform state file.
terraform {
  backend "s3" {
  # backend configuration will be provided during terraform init using -backend-config option
  # terraform init -backend-config=environments/env_name/backend.tfvars
  }
}