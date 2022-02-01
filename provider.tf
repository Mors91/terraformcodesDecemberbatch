terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
     version = "~> 3.0"
    }
  }
}

terraform {
  required_version = ">=0.12"
}

provider "aws" {
  # Configuration options
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}