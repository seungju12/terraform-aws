### Lambda 레이어 생성 ###
resource "aws_lambda_layer_version" "nodejs20" {
  filename                 = "${path.module}/nodejs_layer.zip"
  layer_name               = "nodejs20_layer"
  compatible_architectures = ["x86_64"]
  compatible_runtimes      = ["nodejs20.x"]
}

### get_blog_item 함수 생성 ###
resource "aws_lambda_function" "get_blog_item" {
  filename         = data.archive_file.get_blog_item.output_path
  function_name    = "qwer_get_blog_item"
  role             = var.lambda_role
  handler          = "index.handler"
  source_code_hash = data.archive_file.get_blog_item.output_base64sha256
  runtime          = "nodejs20.x"
  layers           = [aws_lambda_layer_version.nodejs20.arn]
}

### get_blog_items 함수 생성 ###
resource "aws_lambda_function" "get_blog_items" {
  filename         = data.archive_file.get_blog_items.output_path
  function_name    = "qwer_get_blog_items"
  role             = var.lambda_role
  handler          = "index.handler"
  source_code_hash = data.archive_file.get_blog_items.output_base64sha256
  runtime          = "nodejs20.x"
  layers           = [aws_lambda_layer_version.nodejs20.arn]
}

### get_s3_signed_url 함수 생성 ###
resource "aws_lambda_function" "get_s3_signed_url" {
  filename         = data.archive_file.get_s3_signed_url.output_path
  function_name    = "qwer_get_s3_signed_url"
  role             = var.lambda_role
  handler          = "index.handler"
  source_code_hash = data.archive_file.get_s3_signed_url.output_base64sha256
  runtime          = "nodejs20.x"
  layers           = [aws_lambda_layer_version.nodejs20.arn]
}

### cloudfront_ttl_expired 함수 생성 ###
resource "aws_lambda_function" "cloudfront_ttl_expired" {
  filename         = data.archive_file.cloudfront_ttl_expired.output_path
  function_name    = "qwer_cloudfront_ttl_expired"
  role             = var.lambda_role
  handler          = "index.handler"
  source_code_hash = data.archive_file.cloudfront_ttl_expired.output_base64sha256
  runtime          = "nodejs20.x"
  layers           = [aws_lambda_layer_version.nodejs20.arn]
}

### cognito_signup 함수 생성 ###
resource "aws_lambda_function" "cognito_signup" {
  filename         = data.archive_file.cognito_signup.output_path
  function_name    = "qwer_cognito_signup"
  role             = var.lambda_role
  handler          = "index.handler"
  source_code_hash = data.archive_file.cognito_signup.output_base64sha256
  runtime          = "nodejs20.x"
  layers           = [aws_lambda_layer_version.nodejs20.arn]
}

### post_blog_to_dynamodb 함수 생성 ###
resource "aws_lambda_function" "post_blog_to_dynamodb" {
  filename         = data.archive_file.post_blog_to_dynamodb.output_path
  function_name    = "qwer_post_blog_to_dynamodb"
  role             = var.lambda_role
  handler          = "index.handler"
  source_code_hash = data.archive_file.post_blog_to_dynamodb.output_base64sha256
  runtime          = "nodejs20.x"
  layers           = [aws_lambda_layer_version.nodejs20.arn]
}