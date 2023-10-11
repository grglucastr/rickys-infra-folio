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
  #cloud { }

  required_version = ">= 1.1.0"
}

provider "aws" {
  region = "us-east-1"
}
