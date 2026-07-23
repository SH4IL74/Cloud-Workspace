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

output "vpc_id"{
  value       = aws_vpc.main_vpc.id
  description = "The ID of the created VPC"
}

output "public_subnet_id"{
  value       = aws_subnet.public_subnet.id
  description = "The ID of the public subnet"
}

output "security_group_id"{
  value       = aws_security_group.web_sg.id
  description = "The ID of the web security group"
}

output "lambda_function_name"{
  value      = aws_lambda_function.app_lambda.function_name 
  description = "The name of the Lambda Function"
}

output "lambda_function_arn"{
  value       = aws_lambda_function.app_lambda.arn
  description = "The ARN of the Lambda Function"
}