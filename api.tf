module "api" {
  source = "./modules/api"
  name = "contact-form-api"
  regional = true
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
}