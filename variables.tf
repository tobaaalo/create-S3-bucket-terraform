# AWS Configuration
variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "eu-west-2"
}

# S3 Bucket Configuration
variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  default     = "terraform-created-s3-bucket"  #always change the name of the bucket
}

# Environment Configuration
variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

# Versioning Configuration
variable "enable_versioning" {
  description = "Enable versioning for the S3 bucket"
  type        = bool
  default     = true
}

# File Upload Configuration
variable "upload_directory" {
  description = "Local directory path containing files to upload to S3"
  type        = string
  default     = "./files"
}