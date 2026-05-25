output "ecr_repo_name" {
  value = aws_ecr_repository.study_ecr_repo.name
  description = "ECR Private Repository name."
}