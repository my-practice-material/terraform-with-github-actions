# This file is used to define the input variables for the Terraform configuration.
variable "bucket_name" {
  type        = string
  description = "AWS S3 Bucket Name."
  default     = "study"
}