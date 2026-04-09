# github-actions-terraform
GitHub Actions Workflow for Terraform Deployment.

Terraform with AWS S3 to store tf.state file & AWS DynamoDB to store lock.

1. Create an AWS DynamoDB table named tf.lock with a partition key named LockID (String).
2. Create AWS S3 bucket to use as Terraform backend to store tf.state file.
3. Use AWS CloudFormation template present at path `scripts/cloudformation.yml` to create S3 bucket and DynamoDB table.
4. Use a code repository to store terraform code.
5. Create GitHub Actions workflow to deploy terraform.