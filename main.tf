terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}


resource "aws_s3_bucket" "rickys_website" {
  bucket = var.bucket_name
  bucket_prefix = var.bucket_prefix
}


resource "aws_s3_bucket_website_configuration" "rickys_website_config" {
  bucket = aws_s3_bucket.rickys_website.id

  index_document {
    suffix = "index.html"
  }
}