#! /usr/bin/env bash

set -euo pipefail

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "AWS CLI is not installed. Please install it to proceed."
    exit 1
fi

# Check if Terraform is installed
if ! command -v terraform &> /dev/null; then
    echo "Terraform is not installed. Please install it to proceed."
    exit 1
fi

# Set AWS profile to use for Terraform operations.
export AWS_PROFILE=admin

# Shift to the directory where Terraform configuration files are located.
cd ..

# Initialize Terraform with the backend configuration for the development environment in US East 1 region.
terraform init -backend-config=environments/dev/backend-dev-us-east-1.tfvars
# Generate the execution plan for Terraform, specifying the variable file for the development environment in US East 1 region.
terraform plan -out=tfplan -var-file=environments/dev/dev-us-east-1.tfvars
# Validate the Terraform configuration using the variable file for the development environment in US East 1 region.
terraform validate 
