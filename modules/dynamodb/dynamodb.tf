variable "name" {}
variable "key" {}
variable "billing_mode" {
  default = "PAY_PER_REQUEST"
}

variable "attributes" {
  type = "map"
}


resource "aws_dynamodb_table" "table" {
  name = var.name
  billing_mode = var.billing_mode
  hash_key = var.key

  dynamic "attribute" {
    for_each = var.attributes
    content {
      name = attribute.key
      type = attribute.value
    }
  }
}

output "arn" {
  value = aws_dynamodb_table.table.arn
}


output "name" {
  value = aws_dynamodb_table.table.name
}