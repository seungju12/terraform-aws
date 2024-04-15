### 지역 변수 정의 ###
locals {
  s3_name = data.aws_region.current.name == var.region ? 1 : 2
  lambda_arn = data.aws_region.current.name == var.region ? var.lambda_cloudfront_ttl_expired_arn : var.lambda_cloudfront_ttl_expired_2_arn
  lambda_name = data.aws_region.current == var.region ? var.lambda_cloudfront_ttl_expired_name : var.lambda_cloudfront_ttl_expired_2_name
}

### S3 버킷 생성 ###
resource "aws_s3_bucket" "admin-page" {
  bucket              = "${var.blog}-admin-${local.s3_name}"
  object_lock_enabled = false # 객체 잠금 비활성화
}

### S3 객체 소유권 제어 ###
resource "aws_s3_bucket_ownership_controls" "ownership" {
  bucket = aws_s3_bucket.admin-page.id

  rule {
    object_ownership = "BucketOwnerPreferred" # 버킷 소유자 선호
  }
}

### S3 퍼블릭 액세스 허용 ###
resource "aws_s3_bucket_public_access_block" "access-block" {
  bucket                  = aws_s3_bucket.admin-page.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

### S3 버전 관리 활성화 ###
resource "aws_s3_bucket_versioning" "admin-page-versioning" {
  bucket = aws_s3_bucket.admin-page.id

  versioning_configuration {
    status = "Enabled"
  }
}

### S3 정적 웹 사이트 호스팅 ###
resource "aws_s3_bucket_website_configuration" "static-website" {
  bucket = aws_s3_bucket.admin-page.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "404.html"
  }
}

### S3 정책 적용 ###
resource "aws_s3_bucket_policy" "policy" {
  bucket = aws_s3_bucket.admin-page.id
  policy = templatefile("${path.module}/s3-policy.json.tpl", {
    bucket_name = aws_s3_bucket.admin-page.bucket
  })
  depends_on = [aws_s3_bucket_public_access_block.access-block]
}

resource "aws_lambda_permission" "permission" {
  statement_id = "AllowS3Invocation"
  action = "lambda:InvokeFunction"
  function_name = local.lambda_name
  principal = "s3.amazonaws.com"
  source_arn = aws_s3_bucket.admin-page.arn
}

### 이벤트 알림 Lambda 트리거 연결 ###
resource "aws_s3_bucket_notification" "notification" {
  bucket = aws_s3_bucket.admin-page.id

  lambda_function {
    lambda_function_arn = local.lambda_arn
    events = ["s3:ObjectCreated:*"]
  }
}