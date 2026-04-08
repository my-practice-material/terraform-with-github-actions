bucket         = "tf-state-360496493654-us-east-1"
key            = "terraform.tfstate"
region         = "us-east-1"
# dynamodb_table = "tf.lock" # Since Terraform 1.9.0, you can use `use_lockfile` instead of a DynamoDB table for state locking.
use_lockfile   = true