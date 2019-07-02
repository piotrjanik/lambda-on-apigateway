module "lambda" {
  source = "./modules/lambda"
  description = "Collect Contact Requests"
  memory = "128"
  handler = "handler.handler"
  name = "contact-requests"
  runtime = "nodejs10.x"
  policy = data.aws_iam_policy_document.privileges.json
  zip_file = "contact-requests-collector/build/contact-requests-collector.zip"
  variables = {
    "TOPIC_ARN" = module.topic.arn
  }
}

data "aws_iam_policy_document" "privileges" {
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:PutItem"]
    resources = [
      "arn:aws:dynamodb:*:*:table/contact-requests"]
  }
  statement {
    effect = "Allow"
    actions = [
      "SNS:Publish"]
    resources = [
      module.topic.arn]
  }
}