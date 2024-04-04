### 지역 변수 정의 ###
locals {
  id = data.aws_region.current.name == "ap-northeast-2" ? "seoul-to-osaka" : "osaka-to-seoul"
  bucket_id = data.aws_region.current.name == "ap-northeast-2" ? var.admin_seoul_id : var.admin_osaka_id
  bucket_arn = data.aws_region.current.name == "ap-northeast-2" ? var.admin_osaka_arn : var.admin_seoul_arn
}

### S3 복제 규칙 설정 ###
resource "aws_s3_bucket_replication_configuration" "replicate" {
  bucket = local.bucket_id
  role = var.replication_role_arn
  
  rule {
    id = local.id
    status = "Enabled"
    
    destination {
      bucket = local.bucket_arn
      storage_class = "STANDARD"
    }

    delete_marker_replication {
      status = "Enabled"
    }

    filter {
      prefix = "/"
    }
  }
}
