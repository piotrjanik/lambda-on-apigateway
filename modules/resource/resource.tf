variable "api" {}
variable "region" {}
variable "parent" {
  default = null
}
variable "path" {}
variable "methods" {
  type = "map"
}

variable "schema" {}

variable "validator" {}

resource "aws_api_gateway_resource" "resource" {
  rest_api_id = var.api.id
  parent_id = var.parent != null ? var.parent : var.api.root
  path_part = var.path
}


//TODO: The name "count" is reserved for use in a future version of Terraform. :(
//module "method" {
//  source = "./method"
//  count = length(var.actions)
//  api = var.api
//  method = keys(var.actions)[count.index]
//  function = var.actions[keys(var.actions)[count.index]].function
//  region = var.region
//  resource = aws_api_gateway_resource.resource
//}

resource "aws_api_gateway_model" "model" {
  rest_api_id = var.api.id
  name = replace(var.path, "-", "")
  description = "a JSON schema"
  content_type = "application/json"

  schema = var.schema
}

module "GET" {
  source = "./method"
  api = var.api
  method = "GET"
  methods = var.methods
  region = var.region
  model = aws_api_gateway_model.model.name
  resource = aws_api_gateway_resource.resource
  validator = var.validator
}

module "POST" {
  source = "./method"
  api = var.api
  method = "POST"
  methods = var.methods
  region = var.region
  model = aws_api_gateway_model.model.name
  resource = aws_api_gateway_resource.resource
  validator = var.validator
}

// etc...