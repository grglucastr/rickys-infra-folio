locals {
  s3_origin_id = "rickysS3origin"
}

resource "aws_cloudfront_origin_access_control" "rickys_website_origin_access_control" {
  name                              = aws_s3_bucket.rickys_website.bucket_domain_name
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "s3_distribution" {

  depends_on = [ aws_s3_bucket.rickys_website ]

  origin {
    domain_name              = aws_s3_bucket.rickys_website.bucket_regional_domain_name
    origin_id                = local.s3_origin_id
    origin_access_control_id = aws_cloudfront_origin_access_control.rickys_website_origin_access_control.id
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Rickys Website CloudFront"
  default_root_object = "index.html"


  aliases = ["www.rickys-data.today", "rickys-data.today"] #https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/CNAMEs.html#alternate-domain-names-requirements

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

  price_class = "PriceClass_All"

  
  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  tags = {
    Environment = "production"
  }

  viewer_certificate {
    acm_certificate_arn = var.certificate_arn
    ssl_support_method = "sni-only"
  }
}