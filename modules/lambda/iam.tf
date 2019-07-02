variable "policy" {
}
resource "aws_iam_role" "role" {
  name = format("%s-%s",var.name, "role")
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      }
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "lambda_policy" {
  name = format("%s-%s",var.name, "policy")
  policy = var.policy
  role = aws_iam_role.role.id
}

resource "aws_iam_role_policy" "logs" {
  name = format("%s-%s",var.name, "logs")
  policy = data.aws_iam_policy_document.logs.json
  role = aws_iam_role.role.id
}

data "aws_iam_policy_document" "logs" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup"]
    resources = [
      "arn:aws:logs:*:*:*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"]
    resources = [
      "arn:aws:logs:*:*:*"]
  }
}