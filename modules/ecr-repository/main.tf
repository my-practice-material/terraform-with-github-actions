resource "aws_ecr_repository" "study_ecr_repo" {
  name                 = var.ecr_repo_name
  image_tag_mutability = "MUTABLE"   # allows overwriting tags
  force_delete         = true        # optional, lets you delete repo even if images exist

  encryption_configuration {
    encryption_type = "AES256"       # default encryption at rest
  }

  image_scanning_configuration {
    scan_on_push = false              # optional, enables vulnerability scanning
  }
}
