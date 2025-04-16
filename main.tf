
module "aws" {
  source                  = "./modules/aws"
  aws_region              = var.aws_region
  s3_bucket_name          = var.s3_bucket_name
  sns_topic_name          = var.sns_topic_name
  sqs_queue_name          = var.sqs_queue_name
  iam_role_name           = var.iam_role_name
  snowflake_iam_user_arn  = var.snowflake_iam_user_arn
  snowflake_external_id   = var.snowflake_external_id
}

module "snowflake" {
  source                    = "./modules/snowflake"
  snowflake_account         = var.snowflake_account
  snowflake_user            = var.snowflake_user
  snowflake_password        = var.snowflake_password
  snowflake_role            = var.snowflake_role
  snowflake_region          = var.snowflake_region
  storage_integration_name  = var.storage_integration_name
  iam_role_arn              = module.aws.iam_role_arn
  s3_bucket_name            = module.aws.s3_bucket_name
  stage_name                = var.stage_name
  pipe_name                 = var.pipe_name
  database                  = var.database
  schema                    = var.schema
  table_name                = var.table_name
}
