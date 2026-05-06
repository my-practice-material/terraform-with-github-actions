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

# Destroy the Terraform-managed infrastructure, development environment in US East 1 region, 
# and automatically approve the destruction without prompting for confirmation.
terraform destroy --auto-approve