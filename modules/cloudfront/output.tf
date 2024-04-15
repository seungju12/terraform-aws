output "domain_name1" {
  value = aws_cloudfront_distribution.admin.domain_name
}

output "domain_name2" {
  value = aws_cloudfront_distribution.admin_2.domain_name
}

output "zone_id1" {
  value = aws_cloudfront_distribution.admin.hosted_zone_id
}

output "zone_id2" {
  value = aws_cloudfront_distribution.admin_2.hosted_zone_id
}