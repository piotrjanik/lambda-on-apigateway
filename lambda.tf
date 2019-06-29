module "lambda" {
  source = "./modules/lambda"
  description = "Collect Contact Requests"
  memory = "128"
  handler = "handler.handler"
  name = "contacts-req-collectors"
  runtime = "nodejs10.x"
  policy = data.aws_iam_policy_document.table.json
  source_dir = "contact-requests-collector/dist"
  variables = {
    "TEST" = "TEST"
  }
}

data "aws_iam_policy_document" "table" {
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:PutItem"]
    resources = [
      "arn:aws:dynamodb:*:*:table/contact-requests"]
  }
}