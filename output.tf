# This file is used to define the output variables for the Terraform configuration.

output "created_s3_bucket_arn" {
   description = "The ARN of the created S3 Bucket."
   value       = module.create_s3_bucket.bucket_arn
}

output "vpc_id" {
  description = "The ID of the created VPC."
  value       = module.create_vpc.vpc_id
}
