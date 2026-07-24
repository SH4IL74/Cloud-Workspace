output "s3_bucket_name" {
    value = aws_s3_bucket.my_s3_bucket.id
    description = "The name of the created bucket"
}

output "s3-bucket-arn" {
    value = aws_s3_bucket.my_s3_bucket.arn
    description = "The arn of the created bucket"
}

output "dynamodb_table_name" {
    value = aws_dynamodb_table.my_dynamodb_table.id
    description = "The name of the dunamodb table created"
}

output "vpc_id" {
    value = aws_vpc.main_vpc.id
    description = "The ID of the vpc"
}

output "public_subnet_id" {
    value = aws_subnet.public_subnet.id
    description = "The ID of the public subnet"
}