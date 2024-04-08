### 지역 변수 정의 ###
locals {
  s3_name = data.aws_region.current.name == "ap-northeast-2" ? 1 : 2
}

### S3 버킷 생성 ###
resource "aws_s3_bucket" "md" {
  bucket = "qwerblog-md-${local.s3_name}"
  object_lock_enabled = false
}

### S3 객체 소유권 제어 ###
resource "aws_s3_bucket_ownership_controls" "ownership" {
  bucket = aws_s3_bucket.md.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

### S3 퍼블릭 액세스 허용 ###
resource "aws_s3_bucket_public_access_block" "access-block" {
  bucket = aws_s3_bucket.md.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

### S3 버전 관리 활성화 ###
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.md.id

  versioning_configuration {
    status = "Enabled"
  }
}

### S3 정책 적용 ###
resource "aws_s3_bucket_policy" "policy" {
  bucket = aws_s3_bucket.md.id
  policy = templatefile("${path.module}/s3-policy.json.tpl", {
    bucket_name = aws_s3_bucket.md.bucket
  })
  depends_on = [ aws_s3_bucket_public_access_block.access-block ]
}