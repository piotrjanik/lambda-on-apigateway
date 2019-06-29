variable "name" {}
variable "handler" {}
variable "memory" {}
variable "logs" {
  default = true
}
variable "logs_retention" {
  default = 3
}
variable "runtime" {}
variable "description" {}
variable "source_dir" {}
variable "variables" {}

locals {
  zip_file_path = "${dirname(var.name)}/${basename(var.name)}.zip"
}

resource aws_cloudwatch_log_group logs {
  count = var.logs ? 1 : 0
  name = "/aws/lambda/${aws_lambda_function.lambda.function_name}"
  retention_in_days = var.logs_retention
}

data "archive_file" "zip" {
  type = "zip"
  output_path = local.zip_file_path
  source_dir = var.source_dir
}

resource aws_lambda_function lambda {
  description = var.description
  function_name = var.name
  filename = local.zip_file_path
  memory_size = var.memory
  role = aws_iam_role.role.arn
  runtime = var.runtime
  source_code_hash = filemd5(local.zip_file_path)

  environment {
    variables = var.variables
  }

  handler = var.handler
}

output "name" {
  value = aws_lambda_function.lambda.function_name
}

output "arn" {
  value = aws_lambda_function.lambda.arn
}