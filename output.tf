# This file is used to define the output variables for the Terraform configuration.

output "vpc_id" {
  description = "The ID of the created VPC."
  value       = module.create_vpc.vpc_id
}
