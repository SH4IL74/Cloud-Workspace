output "s3_bucket_name"{
  value       = aws_s3_bucket.app_storage.id
  description = "The name of the created S3 bucket"
}

output "s3_bucket_arn"{
  value       = aws_s3_bucket.app_storage.arn
  description = "The ARN of the created S3 bucket"
}

output "dynamodb_table_name"{
  value       = aws_dynamodb_table.users_table.name
  description = "The name of the DynamoDB Table"
}