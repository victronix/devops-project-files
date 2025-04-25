variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket to monitor"
  type        = string
}

variable "cloudfront_distribution_id" {
  description = "ID of the CloudFront distribution to monitor"
  type        = string
}

variable "alert_email" {
  description = "Email address to receive alerts"
  type        = string
} 