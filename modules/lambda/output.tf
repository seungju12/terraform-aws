output "lambda_get_blog_item_name" {
  value = aws_lambda_function.get_blog_item.function_name
}

output "lambda_get_blog_items_name" {
  value = aws_lambda_function.get_blog_items.function_name
}

output "lambda_get_s3_signed_url_name" {
  value = aws_lambda_function.get_s3_signed_url.function_name
}

output "lambda_post_blog_to_dynamodb_name" {
  value = aws_lambda_function.post_blog_to_dynamodb.function_name
}

output "lambda_get_blog_item_arn" {
  value = aws_lambda_function.get_blog_item.invoke_arn
}

output "lambda_get_blog_items_arn" {
  value = aws_lambda_function.get_blog_items.invoke_arn
}

output "lambda_get_s3_signed_url_arn" {
  value = aws_lambda_function.get_s3_signed_url.invoke_arn
}

output "lambda_post_blog_to_dynamodb_arn" {
  value = aws_lambda_function.post_blog_to_dynamodb.invoke_arn
}