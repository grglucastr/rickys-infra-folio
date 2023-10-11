terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # comment this line when working with terraform locally
  # cloud { }

  required_version = ">= 1.1.0"
}

provider "aws" {
  region = "us-east-1"
}

locals {
  bucket_name         = "bennun-labs-rickys-website"
  s3_origin_id        = "rickysS3origin"
}