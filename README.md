# Frontend Static Deployment Infrastructure

This repository contains the AWS infrastructure configuration for deploying our static frontend website. It uses Terraform to set up an S3 bucket for hosting and CloudFront for content delivery.

## Overview

The infrastructure includes:

- S3 bucket for static website hosting
- CloudFront distribution for global content delivery
- IAM roles and policies for GitHub Actions deployments
- OIDC authentication between GitHub and AWS

## Prerequisites

Before you begin, make sure you have:

- [Terraform](https://www.terraform.io/downloads.html) installed (v1.0+)
- AWS CLI configured with appropriate credentials
- GitHub repository with Actions enabled

## Getting Started

1. Clone this repository:
```bash
git clone <repository-url>
cd frontend-static-deployment
```

2. Update the `terraform.tfvars` file with your values:
```hcl
project_name = "express-pay-devops-test"
github_owner = "expghDev"  # Your GitHub username/org
github_repo  = "devops-test"  # Your repository name
```

3. Initialize and apply the Terraform configuration:
```bash
terraform init
terraform apply
```

## Important Outputs

After successful deployment, you'll get these outputs:

- `website_bucket`: Name of the S3 bucket
- `cloudfront_distribution_id`: ID of the CloudFront distribution
- `cloudfront_domain_name`: Domain name for accessing your website
- `github_actions_role_arn`: ARN of the IAM role for GitHub Actions

## GitHub Actions Setup

1. Add these secrets to your GitHub repository:
   - `AWS_ROLE_ARN`: The role ARN from terraform output
   - `AWS_REGION`: The AWS region (e.g., us-east-1)

2. Your GitHub Actions workflow can now use OIDC authentication:
```yaml
permissions:
  id-token: write
  contents: read

steps:
  - uses: aws-actions/configure-aws-credentials@v1
    with:
      role-to-assume: ${{ secrets.AWS_ROLE_ARN }}
      aws-region: ${{ secrets.AWS_REGION }}
```

## Security Features

- S3 bucket is private with no public access
- CloudFront uses Origin Access Identity
- GitHub Actions uses OIDC for secure authentication
- All resources follow AWS security best practices

## Maintenance

To update the infrastructure:

1. Make changes to the Terraform files
2. Run `terraform plan` to review changes
3. Run `terraform apply` to apply changes

To destroy the infrastructure:
```bash
terraform destroy
```