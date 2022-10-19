terraform {
  required_version = ">= 0.12"

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



