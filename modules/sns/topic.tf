variable "name" {}
resource "aws_sns_topic" "topic" {
  name = "contact-requests-topic"
}

output "arn" {
  value = aws_sns_topic.topic.arn
}