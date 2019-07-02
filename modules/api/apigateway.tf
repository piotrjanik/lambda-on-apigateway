variable "name" {}
variable "regional" {
  default = true
}
variable "stage" {}
variable "deploy" {
  default = false
}
locals {
  type = var.regional ? "REGIONAL" : "EDGE"
}

resource "aws_api_gateway_rest_api" "gateway" {
  name = var.name

  endpoint_configuration {
    types = [
      "REGIONAL"]
  }
}

resource "aws_api_gateway_request_validator" "validator" {
  name = "body-validator"
  rest_api_id = aws_api_gateway_rest_api.gateway.id
  validate_request_body = true
  validate_request_parameters = false
}

resource "aws_api_gateway_deployment" "deployment" {
  count = var.deploy ? 1 : 0
  rest_api_id = aws_api_gateway_rest_api.gateway.id
  stage_name = var.stage
  description = timestamp()
}

output "id" {
  value = aws_api_gateway_rest_api.gateway.id
}

output "root" {
  value = aws_api_gateway_rest_api.gateway.root_resource_id
}

output "arn" {
  value = aws_api_gateway_rest_api.gateway.execution_arn
}

output "body_validator_id" {
  value = aws_api_gateway_request_validator.validator.id
}
