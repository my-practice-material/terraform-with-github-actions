# Get current AWS account identity
data "aws_caller_identity" "current" {}

module "create_s3_bucket" {
    source        = "./modules/s3"
    bucket_name   = "${var.bucket_name}-${data.aws_caller_identity.current.account_id}"
}
