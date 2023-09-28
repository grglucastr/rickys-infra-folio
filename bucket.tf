resource "aws_s3_bucket" "rickys_website" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_policy" "rickys_website_policy" {
  depends_on = [ aws_cloudfront_distribution.s3_distribution ]
  bucket = aws_s3_bucket.rickys_website.id
  policy = data.aws_iam_policy_document.rickys_website_policy_document.json
}

resource "aws_s3_object" "placeholder_file" {
  bucket = var.bucket_name
  key    = "index.html"
  source = "index.html"
  etag = filemd5("index.html")
}

data "aws_iam_policy_document" "rickys_website_policy_document" {
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
      "${aws_s3_bucket.rickys_website.arn}/*"
    ]

    condition {
      test = "StringEquals"
      variable = "AWS:SourceArn"
      values = [aws_cloudfront_distribution.s3_distribution.arn]
    }
  }
}