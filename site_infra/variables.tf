variable "cloudfront_comment" {
  default = "Rickys Website CloudFront"
}

variable "cloudfront_default_root_object" {
  default = "index.html"
}

variable "cloudfront_aliases" {
  type    = list(string)
  default = []
}

variable "cloudfront_viewer_protocol_policy" {
  default = "redirect-to-https"
}

variable "cloudfront_price_class" {
  default = "PriceClass_All"
}

variable "CLOUDFRONT_CERTIFICATE_ARN" {
  description = "Certificate ARN comes from Enviroment variable"
}

variable "cloudfront_ssl_support_method" {
  default = "sni-only"
}

variable "cloudfront_minimum_protocol_version" {
  default = "TLSv1.2_2021"
}