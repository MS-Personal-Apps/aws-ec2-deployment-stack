terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.24.0"
    }
  }
  backend "s3" {
    encrypt = true
  }
}


provider "aws" {
  profile = var.profile
  region  = "us-west-1"
  default_tags {
    tags = {
      Repository_name = "aws-ec2-deployment-stack"
      Created_by      = "terraform"
      Environment     = title(terraform.workspace)
    }
  }
}
