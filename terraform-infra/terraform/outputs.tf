output "dev_s3_bucket"{
    value       = module.dev_environment.s3_bucket_name
    description = "S3 bucket for DEV"
}

output "staging_s3_bucket"{
    value       = module.staging_environment.s3_bucket_name
    description = "S3 bucket for STAGING"
}

output "dev_lambda_function"{
    value       = module.dev_environment.lambda_function_name
    description = "Lambda function for DEV"
}
output "staging_lambda_function"{
    value       = module.staging_environment.lambda_function_name
    description = "Lambda function for STAGING"
}