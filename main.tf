terraform {
  required_version = ">= 0.12"

  # vars are not allowed in this block
  # see: https://github.com/hashicorp/terraform/issues/22088
  backend "s3" {}

  required_providers {
    aws = {
      source  = "aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region  = var.region
}



