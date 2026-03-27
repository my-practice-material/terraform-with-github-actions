bucket         = "tf-state-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}"
key            = "terraform.tfstate"
region         = "us-east-1"
dynamodb_table = "tf.lock"