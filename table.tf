module "table" {
  source = "./modules/dynamodb"
  name = "contact-requests"
  key = "uuid"
  attributes = {
    "uuid" = "S"
  }
}