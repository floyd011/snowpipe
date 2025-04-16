
provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "ingest_bucket" {
  bucket = var.s3_bucket_name
}

resource "aws_sns_topic" "snowpipe_topic" {
  name = var.sns_topic_name
}

resource "aws_sqs_queue" "snowpipe_queue" {
  name = var.sqs_queue_name
}

resource "aws_sns_topic_subscription" "sqs_sub" {
  topic_arn = aws_sns_topic.snowpipe_topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.snowpipe_queue.arn
}

resource "aws_s3_bucket_notification" "s3_event_notification" {
  bucket = aws_s3_bucket.ingest_bucket.id

  topic {
    topic_arn = aws_sns_topic.snowpipe_topic.arn
    events    = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_sns_topic.snowpipe_topic]
}

resource "aws_iam_role" "snowflake_role" {
  name = var.iam_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        AWS = var.snowflake_iam_user_arn
      }
      Action = "sts:AssumeRole"
      Condition = {
        StringEquals = {
          "sts:ExternalId" = var.snowflake_external_id
        }
      }
    }]
  })
}

resource "aws_iam_policy" "snowpipe_policy" {
  name        = "SnowpipeS3SQSPolicy"
  description = "Policy to allow Snowflake to access S3 and SQS"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:GetObject", "s3:ListBucket"]
        Resource = [
          aws_s3_bucket.ingest_bucket.arn,
          "${aws_s3_bucket.ingest_bucket.arn}/*"
        ]
      },
      {
        Effect   = "Allow"
        Action   = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes"
        ]
        Resource = aws_sqs_queue.snowpipe_queue.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.snowflake_role.name
  policy_arn = aws_iam_policy.snowpipe_policy.arn
}
