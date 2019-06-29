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
}

resource "aws_api_gateway_integration" "integration" {
  count = local.count
  rest_api_id = var.api.id
  resource_id = var.resource.id
  http_method = element(aws_api_gateway_method.method.*.http_method, 0)
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${var.methods[var.method]["arn"]}/invocations"
}

resource "aws_lambda_permission" "apigw_lambda" {
  count = local.count
  statement_id = "AllowExecutionFromAPIGateway"
  action = "lambda:InvokeFunction"
  function_name = var.methods[var.method]["name"]
  principal = "apigateway.amazonaws.com"
  source_arn = var.api.arn
}