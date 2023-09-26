terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}


resource "aws_s3_bucket" "rickys_website" {
  bucket = var.bucket_name
}


resource "aws_s3_bucket_website_configuration" "rickys_website_config" {
  bucket = aws_s3_bucket.rickys_website.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_ownership_controls" "rickys_website_ownership_controls" {
  bucket = aws_s3_bucket.rickys_website.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "rickys_website_access_block" {
  bucket = aws_s3_bucket.rickys_website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "rickys_website_acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.rickys_website_ownership_controls,
    aws_s3_bucket_public_access_block.rickys_website_access_block,
  ]

  bucket = aws_s3_bucket.rickys_website.id
  acl    = "public-read"
}

resource "aws_s3_bucket_policy" "rickys_website_policy" {
  bucket = aws_s3_bucket.rickys_website.id
  policy = data.aws_iam_policy_document.rickys_website_policy_document.json
}

data "aws_iam_policy_document" "rickys_website_policy_document" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.rickys_website.arn}/*"
    ]
  }
}