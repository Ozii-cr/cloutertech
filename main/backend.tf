provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Terraform   = "true"
      Environment = var.provider_environment
    }
  }
}

terraform {
  required_version = "~> 1.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.92.0"
    }
  }

  backend "s3" {
    bucket       = ""
    key          = "terraform.tfstate"
    encrypt      = true
    region       = "ap-south-1"
    use_lockfile = true
  }
}
