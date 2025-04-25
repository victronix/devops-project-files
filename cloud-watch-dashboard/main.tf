provider "aws" {
  region = var.aws_region
}

# CloudWatch
resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${var.project_name}-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      # S3 Bucket Metrics
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            ["AWS/S3", "NumberOfObjects", "BucketName", var.s3_bucket_name],
            [".", "BucketSizeBytes", ".", "."]
          ]
          period = 300
          stat   = "Average"
          region = var.aws_region
          title  = "S3 Bucket Metrics"
        }
      },
      # CloudFront Performance
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            ["AWS/CloudFront", "Requests", "DistributionId", var.cloudfront_distribution_id],
            [".", "BytesDownloaded", ".", "."],
            [".", "4xxErrorRate", ".", "."],
            [".", "5xxErrorRate", ".", "."]
          ]
          period = 300
          stat   = "Sum"
          region = "us-east-1"  # CloudFront metrics are in us-east-1
          title  = "CloudFront Performance"
        }
      },
      {
        type   = "log"
        x      = 0
        y      = 6
        width  = 24
        height = 6

        properties = {
          query = "fields @timestamp, @message | filter @logStream like /vpc-flow-logs/"
          region = var.aws_region
          title  = "VPC Flow Logs"
        }
      }
    ]
  })
}

# CloudWatch Alarms

resource "aws_cloudwatch_metric_alarm" "error_rate" {
  alarm_name          = "${var.project_name}-high-error-rate"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "5xxErrorRate"
  namespace           = "AWS/CloudFront"
  period             = "300"
  statistic          = "Average"
  threshold          = "5"
  alarm_description  = "This metric monitors CloudFront error rate"
  alarm_actions      = [aws_sns_topic.alerts.arn]

  dimensions = {
    DistributionId = var.cloudfront_distribution_id
  }
}

resource "aws_cloudwatch_metric_alarm" "bucket_size" {
  alarm_name          = "${var.project_name}-bucket-size"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "BucketSizeBytes"
  namespace           = "AWS/S3"
  period             = "86400"
  statistic          = "Average"
  threshold          = "5000000000"  # 5GB
  alarm_description  = "This metric monitors S3 bucket size"
  alarm_actions      = [aws_sns_topic.alerts.arn]

  dimensions = {
    BucketName = var.s3_bucket_name
  }
}

resource "aws_cloudwatch_metric_alarm" "request_count" {
  alarm_name          = "${var.project_name}-high-request-count"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "Requests"
  namespace           = "AWS/CloudFront"
  period             = "300"
  statistic          = "Sum"
  threshold          = "10000"
  alarm_description  = "This metric monitors number of requests"
  alarm_actions      = [aws_sns_topic.alerts.arn]

  dimensions = {
    DistributionId = var.cloudfront_distribution_id
  }
}

resource "aws_sns_topic" "alerts" {
  name = "${var.project_name}-alerts"
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
} 