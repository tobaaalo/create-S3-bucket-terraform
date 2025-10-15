# Configure AWS Provider
provider "aws" {
  region = var.aws_region
}

# Generate a random suffix to ensure the S3 bucket name is globally unique
resource "random_id" "suffix" {
  byte_length = 4
}

# Create S3 Bucket
resource "aws_s3_bucket" "main_bucket" {
  bucket        = "${var.bucket_name}-${random_id.suffix.hex}"
  force_destroy = true  # Allows Terraform to delete bucket even if it contains objects

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Enable versioning 
resource "aws_s3_bucket_versioning" "main_bucket_versioning" {
  bucket = aws_s3_bucket.main_bucket.id

  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Disabled"
  }
}

# Allow public access
resource "aws_s3_bucket_public_access_block" "main_bucket_pab" {
  bucket = aws_s3_bucket.main_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "main_bucket_encryption" {
  bucket = aws_s3_bucket.main_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Bucket policy to allow public read access
resource "aws_s3_bucket_policy" "public_read_policy" {
  bucket = aws_s3_bucket.main_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.main_bucket.arn}/*"
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.main_bucket_pab]
}

# Upload files to S3 bucket
resource "aws_s3_object" "uploaded_files" {
  for_each = fileset(var.upload_directory, "**/*")

  bucket       = aws_s3_bucket.main_bucket.id
  key          = each.value
  source       = "${var.upload_directory}/${each.value}"
  etag         = filemd5("${var.upload_directory}/${each.value}")
  content_type = lookup(local.mime_types, regex("\\.[^.]+$", each.value), "application/octet-stream")

  tags = {
    Name      = each.value
    ManagedBy = "Terraform"
  }
}

# MIME types for common file extensions
locals {
  mime_types = {
    ".html" = "text/html"
    ".css"  = "text/css"
    ".js"   = "application/javascript"
    ".json" = "application/json"
    ".png"  = "image/png"
    ".jpg"  = "image/jpeg"
    ".jpeg" = "image/jpeg"
    ".gif"  = "image/gif"
    ".svg"  = "image/svg+xml"
    ".txt"  = "text/plain"
    ".pdf"  = "application/pdf"
    ".xml"  = "application/xml"
  }
}