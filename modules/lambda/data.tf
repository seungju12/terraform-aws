data "archive_file" "get_blog_item" {
  type = "zip"
  source_file = "${path.module}/function/get_blog_item/index.mjs"
  output_path = "${path.module}/function/get_blog_item/index.zip"
}

data "archive_file" "get_blog_items" {
  type = "zip"
  source_file = "${path.module}/function/get_blog_items/index.mjs"
  output_path = "${path.module}/function/get_blog_items/index.zip"
}

data "archive_file" "get_s3_signed_url" {
  type = "zip"
  source_file = "${path.module}/function/get_s3_signed_url/index.mjs"
  output_path = "${path.module}/function/get_s3_signed_url/index.zip"
}

data "archive_file" "cloudfront_ttl_expired" {
  type = "zip"
  source_file = "${path.module}/function/cloudfront_ttl_expired/index.mjs"
  output_path = "${path.module}/function/cloudfront_ttl_expired/index.zip"
}

data "archive_file" "cognito_signup" {
  type = "zip"
  source_file = "${path.module}/function/cognito_signup/index.mjs"
  output_path = "${path.module}/function/cognito_signup/index.zip"
}

data "archive_file" "post_blog_to_dynamodb" {
  type = "zip"
  source_file = "${path.module}/function/post_blog_to_dynamodb/index.mjs"
  output_path = "${path.module}/function/post_blog_to_dynamodb/index.zip"
}