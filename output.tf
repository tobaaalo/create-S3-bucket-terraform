output "bucket_id" {
  description = "The name of the bucket"
  value       = aws_s3_bucket.main_bucket.id
}

output "bucket_arn" {
  description = "The ARN of the bucket"
  value       = aws_s3_bucket.main_bucket.arn
}

output "bucket_domain_name" {
  description = "The bucket domain name"
  value       = aws_s3_bucket.main_bucket.bucket_domain_name
}

output "bucket_regional_domain_name" {
  description = "The bucket region-specific domain name"
  value       = aws_s3_bucket.main_bucket.bucket_regional_domain_name
}

output "uploaded_files" {
  description = "List of files uploaded to S3"
  value       = keys(aws_s3_object.uploaded_files)
}

output "uploaded_files_count" {
  description = "Number of files uploaded to S3"
  value       = length(aws_s3_object.uploaded_files)
}