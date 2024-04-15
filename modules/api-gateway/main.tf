### HTTP API Gateway 생성 ###
resource "aws_apigatewayv2_api" "http-api" {
  name = "qwer-http"
  protocol_type = "HTTP"
  cors_configuration {
    allow_credentials = false
    allow_headers = ["*"]
    allow_methods = [
        "GET",
        "POST"
    ]
    allow_origins = [
        "http://localhost:3000",
        "https://qwerblog.com",
        "https://admin.qwerblog.com"
    ]
    max_age = 300
  }
}

### API Gateway에 Lambda 권한 부여 ###
resource "aws_lambda_permission" "get_blog_item" {
  action = "lambda:InvokeFunction"
  function_name = var.lambda_get_blog_item_name
  principal = "apigateway.amazonaws.com"
  source_arn = "${aws_apigatewayv2_api.http-api.execution_arn}/*"
}

resource "aws_lambda_permission" "get_blog_items" {
  action = "lambda:InvokeFunction"
  function_name = var.lambda_get_blog_items_name
  principal = "apigateway.amazonaws.com"
  source_arn = "${aws_apigatewayv2_api.http-api.execution_arn}/*"
}

resource "aws_lambda_permission" "post_blog_to_dynamodb" {
  action = "lambda:InvokeFunction"
  function_name = var.lambda_post_blog_to_dynamodb_name
  principal = "apigateway.amazonaws.com"
  source_arn = "${aws_apigatewayv2_api.http-api.execution_arn}/*"
}

resource "aws_lambda_permission" "get_s3_signed_url" {
  action = "lambda:InvokeFunction"
  function_name = var.lambda_get_s3_signed_url_name
  principal = "apigateway.amazonaws.com"
  source_arn = "${aws_apigatewayv2_api.http-api.execution_arn}/*"
}

### API Gateway와 Lambda 통합 ###
resource "aws_apigatewayv2_integration" "get_blog_item" {
  api_id = aws_apigatewayv2_api.http-api.id
  integration_type = "AWS_PROXY"
  integration_uri = var.lambda_get_blog_item_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_integration" "get_blog_items" {
  api_id = aws_apigatewayv2_api.http-api.id
  integration_type = "AWS_PROXY"
  integration_uri = var.lambda_get_blog_items_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_integration" "post_blog_to_dynamodb" {
  api_id = aws_apigatewayv2_api.http-api.id
  integration_type = "AWS_PROXY"
  integration_uri = var.lambda_post_blog_to_dynamodb_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_integration" "get_s3_signed_url" {
  api_id = aws_apigatewayv2_api.http-api.id
  integration_type = "AWS_PROXY"
  integration_uri = var.lambda_get_s3_signed_url_arn
  payload_format_version = "2.0"
}

### 메소드 경로 설정 ###
resource "aws_apigatewayv2_route" "get_blog_item" {
  api_id = aws_apigatewayv2_api.http-api.id
  route_key = "GET /blog"
  target = "integrations/${aws_apigatewayv2_integration.get_blog_item.id}"
}

resource "aws_apigatewayv2_route" "get_blog_items" {
  api_id = aws_apigatewayv2_api.http-api.id
  route_key = "GET /blogs"
  target = "integrations/${aws_apigatewayv2_integration.get_blog_items.id}"
}

resource "aws_apigatewayv2_route" "post_blog_to_dynamodb" {
  api_id = aws_apigatewayv2_api.http-api.id
  route_key = "POST /blog"
  target = "integrations/${aws_apigatewayv2_integration.post_blog_to_dynamodb.id}"
}

resource "aws_apigatewayv2_route" "get_s3_signed_url" {
  api_id = aws_apigatewayv2_api.http-api.id
  route_key = "GET /s3Url"
  target = "integrations/${aws_apigatewayv2_integration.get_s3_signed_url.id}"
}

### 스테이지 생성 ###
resource "aws_apigatewayv2_stage" "stage" {
  api_id = aws_apigatewayv2_api.http-api.id
  name = "test"
  auto_deploy = true
}