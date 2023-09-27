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

locals {
  s3_origin_id = "rickysS3origin"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.rickys_website.bucket_regional_domain_name
    origin_id                = local.s3_origin_id
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Some comment"
  default_root_object = "index.html"


  # aliases = ["mysite.example.com", "yoursite.example.com"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_200"

  
  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB", "DE", "BR", "AR"]
    }
  }

  tags = {
    Environment = "production"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}