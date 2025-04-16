
provider "snowflake" {
  account   = var.snowflake_account
  username  = var.snowflake_user
  password  = var.snowflake_password
  role      = var.snowflake_role
  region    = var.snowflake_region
}

resource "snowflake_storage_integration" "s3_integration" {
  name                      = var.storage_integration_name
  storage_provider          = "S3"
  enabled                   = true
  storage_aws_role_arn      = var.iam_role_arn
  storage_allowed_locations = ["s3://${var.s3_bucket_name}"]
}

resource "snowflake_stage" "s3_stage" {
  name                = var.stage_name
  url                 = "s3://${var.s3_bucket_name}/"
  storage_integration = snowflake_storage_integration.s3_integration.name
  file_format         = "TYPE = JSON"
  database            = var.database
  schema              = var.schema
}

resource "snowflake_pipe" "snowpipe" {
  name         = var.pipe_name
  database     = var.database
  schema       = var.schema
  auto_ingest  = true
  copy_statement = <<EOT
COPY INTO ${var.database}.${var.schema}.${var.table_name}
FROM @${snowflake_stage.s3_stage.name}
FILE_FORMAT = (TYPE = JSON)
EOT
}
