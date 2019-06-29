variable "name" {}
variable "regional" { default = true}

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

output "id" {
  value = aws_api_gateway_rest_api.gateway.id
}

output "root" {
  value = aws_api_gateway_rest_api.gateway.root_resource_id
}

output "arn" {
  value = aws_api_gateway_rest_api.gateway.execution_arn
}