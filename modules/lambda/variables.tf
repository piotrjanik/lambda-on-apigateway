variable "name" {}
variable "handler" {}
variable "memory" {}
variable "logs" {
  default = true
}
variable "logs_retention" {
  default = 3
}
variable "runtime" {}
variable "description" {}
variable "zip_file" {}
variable "variables" {}
variable "timeout" {
  default = 30
}