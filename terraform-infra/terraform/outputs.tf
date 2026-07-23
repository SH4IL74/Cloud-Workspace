output "active_workspace" {
  value       = terraform.workspace
  description = "The active Terraform workspace"
}

output "s3_bucket_name" {
  value       = module.app_environment.s3_bucket_name
  description = "S3 bucket for the active workspace"
}

output "lambda_function_name" {
  value       = module.app_environment.lambda_function_name
  description = "Lambda function for the active workspace"
}

output "vpc_id" {
  value       = module.app_environment.vpc_id
  description = "VPC ID for the active workspace"
}