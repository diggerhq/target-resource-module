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

variable "public_subnet_ids" {}

variable "private_subnet_ids" {}

variable "security_group_ids" {}

variable "tags" {
  default = {created_by: "digger"}
}