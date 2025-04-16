
# Terraform Snowpipe Integration

This project provides a complete Terraform setup to integrate AWS services (S3, SNS, SQS, IAM) with Snowflake's Snowpipe for automatic data ingestion.

## Structure

- **modules/aws**: Creates the required AWS infrastructure.
  - S3 bucket for data ingestion
  - SNS topic for event notifications
  - SQS queue subscribed to the SNS topic
  - IAM role with permissions for Snowflake to access S3 and SQS

- **modules/snowflake**: Sets up Snowflake objects.
  - Storage integration
  - External stage pointing to S3
  - Snowpipe with auto-ingest using the SQS queue

## Prerequisites

- AWS account with Terraform access
- Snowflake account with required permissions
- Terraform installed locally

## Setup

1. Fill out `terraform.tfvars` with your values:
   ```hcl
   aws_region              = "us-east-1"
   s3_bucket_name          = "my-ingest-bucket"
   ...
   ```

2. Initialize and apply Terraform:
   ```bash
   terraform init
   terraform apply
   ```

3. After apply, your Snowpipe will be ready to auto-ingest new files uploaded to S3.

## Outputs

The following outputs will be available:
- S3 bucket name
- SNS topic ARN
- SQS queue ARN
- IAM role ARN

## Notes

- Ensure the `external_id` and `iam_user_arn` values match the Snowflake-provided values from the `CREATE STORAGE INTEGRATION` step in Snowflake.
- The IAM role must be manually trusted by Snowflake using the `ALTER STORAGE INTEGRATION` command.

## Authors

Created by [DataMeshSync](https://linkedin.com/company/datamesh-sync)
