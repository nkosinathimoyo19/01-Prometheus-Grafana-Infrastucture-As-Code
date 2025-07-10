# Terraform Block

terraform {
  required_version = "~> 1.7.3"  #allows right most version to be used
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

# Providers Block

provider "aws" {
  region = var.aws_region
}


