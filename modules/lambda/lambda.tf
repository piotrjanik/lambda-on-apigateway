locals {
  zip_file_path = "${dirname(var.name)}/${basename(var.name)}.zip"
}

resource aws_cloudwatch_log_group logs {
  count = var.logs ? 1 : 0
  name = "/aws/lambda/${aws_lambda_function.lambda.function_name}"
  retention_in_days = var.logs_retention
}

resource aws_lambda_function lambda {
  description = var.description
  function_name = var.name
  filename = var.zip_file
  source_code_hash = filemd5(var.zip_file)
  memory_size = var.memory
  role = aws_iam_role.role.arn
  runtime = var.runtime
  timeout = var.timeout
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