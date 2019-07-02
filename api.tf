variable "deploy" {
  default = false
}
module "api" {
  source = "./modules/api"
  name = "contact-requests-api"
  regional = true
  stage = "test"
  deploy = var.deploy
}

module "resource" {
  source = "./modules/resource"
  api = module.api
  region = "eu-west-1"
  path = "contact-requests"

  methods = {
    "POST" = {
      "arn" = module.lambda.arn
      "name" = module.lambda.name
    }
  }
  validator = module.api.body_validator_id

  schema = <<EOF
{
  "definitions": {},
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "title": "The Root Schema",
  "required": [
    "name",
    "email",
    "message"
  ],
  "properties": {
    "name": {
      "type": "string",
      "title": "The Name Schema",
      "pattern": "^(.*)$"
    },
    "email": {
      "type": "string",
      "pattern": "^(.*)$"
    },
    "message": {
      "type": "string",
      "title": "The Message Schema",
      "pattern": "^(.*)$"
    }
  }
}
EOF

}
