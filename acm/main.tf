terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.52.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
  }
  
  # comment this line when working with terraform locally
  cloud { }

  required_version = ">= 1.1.0"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_acm_certificate" "cert" {
  domain_name         = var.domain_name
  validation_method   = "DNS"

  subject_alternative_names = var.domain_alternative_names

  lifecycle {
    create_before_destroy = true
  }
}