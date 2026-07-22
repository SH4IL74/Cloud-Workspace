# Create a test S3 Bucket on LocalStack
resource "aws_s3_bucket" "my_test_bucket" {
  bucket = "shail-localstack-demo-bucket"
}