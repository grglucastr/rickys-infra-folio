resource "aws_s3_bucket" "project_bucket" {
  bucket = local.bucket_name
}

resource "aws_s3_bucket_policy" "project_bucket_policy" {
  depends_on = [ aws_cloudfront_distribution.s3_distribution ]
  bucket = aws_s3_bucket.project_bucket.id
  policy = data.aws_iam_policy_document.project_bucket_policy_document.json
}

resource "aws_s3_object" "placeholder_file" {
  bucket          = aws_s3_bucket.project_bucket.id
  key             = "index.html"
  source          = "index.html"
  content_type    = "text/html"
}

resource "aws_s3_bucket_lifecycle_configuration" "bucket_lifecycle" {
  bucket = aws_s3_bucket.project_bucket.id
  rule {
    id = "storage_class_rule"
    status = "Enabled"
    transition {
      days = 30
      storage_class = "ONEZONE_IA"
    }
  }
  
}

data "aws_iam_policy_document" "project_bucket_policy_document" {
  statement {

    sid = "AllowCloudFrontServicePrincipal"
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    
    actions = [
      "s3:GetObject",
      "s3:PutObject"
    ]

    resources = [
      "${aws_s3_bucket.project_bucket.arn}/*"
    ]

    condition {
      test = "StringEquals"
      variable = "AWS:SourceArn"
      values = [aws_cloudfront_distribution.s3_distribution.arn]
    }
  }
}