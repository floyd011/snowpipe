
output "s3_bucket_name" { value = aws_s3_bucket.ingest_bucket.bucket }
output "sns_topic_arn" { value = aws_sns_topic.snowpipe_topic.arn }
output "sqs_queue_arn" { value = aws_sqs_queue.snowpipe_queue.arn }
output "iam_role_arn" { value = aws_iam_role.snowflake_role.arn }
