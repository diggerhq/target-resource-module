/*
 * variables.tf
 * Common variables to use in various Terraform files (*.tf)
 */

variable "region" {
  default = "us-east-1"
}

variable "aws_key" {}

variable "aws_secret" {}

variable "vpc_id" {}

variable "aws_app_identifier" {}

variable "public_subnets" {}

variable "private_subnets" {}

variable "security_groups" {}

variable "tags" {
  default = {created_by: "digger"}
}