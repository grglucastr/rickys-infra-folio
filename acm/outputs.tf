output "cname_names" {
  value = aws_acm_certificate.cert.domain_validation_options.*.resource_record_name
}

output "cname_values" {
  value = aws_acm_certificate.cert.domain_validation_options.*.resource_record_value
}

output "certificate_arn" {
  value =  aws_acm_certificate.cert.arn
}