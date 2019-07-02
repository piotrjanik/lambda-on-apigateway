variable "api" {}
variable "region" {}
variable "resource" {}
variable "method" {}
variable "methods" {
  type = "map"
}
variable "authorization" {
  default = "NONE"
}

variable "model" {}

variable "validator" {}

locals {
  active = contains(keys(var.methods), var.method)
  count = local.active ? 1 : 0
  //  method_config = local.active ? var.methods[var.method] : null
}

resource "aws_api_gateway_method" "method" {
  count = local.count
  rest_api_id = var.api.id
  resource_id = var.resource.id
  http_method = var.method
  authorization = var.authorization
  request_models = {
    "application/json" = var.model
  }
  request_validator_id = var.validator
}


resource "aws_api_gateway_integration" "integration" {
  count = local.count
  rest_api_id = var.api.id
  resource_id = var.resource.id
  http_method = aws_api_gateway_method.method.*.http_method[0]
  integration_http_method = "POST"
  type = "AWS"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${var.methods[var.method]["arn"]}/invocations"
  request_templates = {
    "application/json" = <<EOF
$input.json('$')
EOF
  }
}

resource "aws_api_gateway_integration_response" "integration_response" {
  count = local.count
  rest_api_id = var.api.id
  resource_id = var.resource.id
  http_method = aws_api_gateway_method.method.*.http_method[0]
  status_code = "200"
  depends_on = [
    "aws_api_gateway_method.method",
    "aws_api_gateway_method_response.ok"
  ]
}

resource "aws_api_gateway_method_response" "ok" {
  count = local.count
  rest_api_id = var.api.id
  resource_id = var.resource.id
  http_method = aws_api_gateway_method.method.*.http_method[0]
  status_code = "200"
}

resource "aws_lambda_permission" "apigw_lambda" {
  count = local.count
  statement_id = "AllowExecutionFromAPIGateway"
  action = "lambda:InvokeFunction"
  function_name = var.methods[var.method]["name"]
  principal = "apigateway.amazonaws.com"
  source_arn = format("%s/*/*", var.api.arn)
}

//CORS

resource "aws_api_gateway_method" "options_method" {
  count = local.count
  rest_api_id = var.api.id
  resource_id = var.resource.id
  http_method = "OPTIONS"
  authorization = "NONE"
}
resource "aws_api_gateway_method_response" "options_200" {
  count = local.count
  rest_api_id = var.api.id
  resource_id = var.resource.id
  http_method = aws_api_gateway_method.options_method.*.http_method[0]
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin" = true
  }
  depends_on = [
    "aws_api_gateway_method.options_method"]
}
resource "aws_api_gateway_integration" "options_integration" {
  count = local.count
  rest_api_id = var.api.id
  resource_id = var.resource.id
  http_method = aws_api_gateway_method.options_method.*.http_method[0]
  type = "MOCK"
  depends_on = [
    "aws_api_gateway_method.options_method"]
}
resource "aws_api_gateway_integration_response" "options_integration_response" {
  count = local.count
  rest_api_id = var.api.id
  resource_id = var.resource.id
  http_method = aws_api_gateway_method.options_method.*.http_method[0]
  status_code = aws_api_gateway_method_response.options_200.*.status_code[0]
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
  depends_on = [
    "aws_api_gateway_method_response.options_200"]
}