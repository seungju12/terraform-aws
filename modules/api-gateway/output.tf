output "api_id" {
  value = aws_apigatewayv2_api.http-api.id
}

output "api_domain_name" {
  value = aws_apigatewayv2_domain_name.api.domain_name_configuration[0].target_domain_name
}

output "api_zone_id" {
  value = aws_apigatewayv2_domain_name.api.domain_name_configuration[0].hosted_zone_id
}