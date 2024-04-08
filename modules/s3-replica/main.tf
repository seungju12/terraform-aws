### 지역 변수 정의 ###
locals {
  id = data.aws_region.current.name == "ap-northeast-2" ? "seoul-to-osaka" : "osaka-to-seoul"
  regions_buckets = {
    "ap-northeast-2" = {
      admin = {
        bucket_id = var.admin_seoul_id,
        dest_arn  = var.admin_osaka_arn
      },
      image = {
        bucket_id = var.image_seoul_id,
        dest_arn  = var.image_osaka_arn
      },
      md = {
        bucket_id = var.md_seoul_id,
        dest_arn  = var.md_osaka_arn
      }
    }
    "ap-northeast-3" = {
      admin = {
        bucket_id = var.admin_osaka_id,
        dest_arn  = var.admin_seoul_arn
      },
      image = {
        bucket_id = var.image_osaka_id,
        dest_arn  = var.image_seoul_arn
      },
      md = {
        bucket_id = var.md_osaka_id,
        dest_arn  = var.md_seoul_arn
      }
    }
  }

  current_admin_bucket = local.regions_buckets[data.aws_region.current.name].admin
  current_image_bucket = local.regions_buckets[data.aws_region.current.name].image
  current_md_bucket    = local.regions_buckets[data.aws_region.current.name].md
}

### admin S3 복제 규칙 설정 ###
resource "aws_s3_bucket_replication_configuration" "admin-replicate" {
  bucket = local.current_admin_bucket.bucket_id
  role   = var.replication_role_arn

  rule {
    id     = local.id
    status = "Enabled"

    destination {
      bucket        = local.current_admin_bucket.dest_arn
      storage_class = "STANDARD"
    }

    delete_marker_replication {
      status = "Enabled" # 삭제 마커 복제
    }

    filter {
      prefix = "/"
    }
  }
}

### image S3 복제 규칙 설정 ###
resource "aws_s3_bucket_replication_configuration" "image-replicate" {
  bucket = local.current_image_bucket.bucket_id
  role   = var.replication_role_arn

  rule {
    id     = local.id
    status = "Enabled"

    destination {
      bucket        = local.current_image_bucket.dest_arn
      storage_class = "STANDARD"
    }

    delete_marker_replication {
      status = "Enabled" # 삭제 마커 복제
    }

    filter {
      prefix = "/"
    }
  }
}

### md S3 복제 규칙 설정 ###
resource "aws_s3_bucket_replication_configuration" "md-replicate" {
  bucket = local.current_md_bucket.bucket_id
  role   = var.replication_role_arn

  rule {
    id     = local.id
    status = "Enabled"

    destination {
      bucket        = local.current_md_bucket.dest_arn
      storage_class = "STANDARD"
    }

    delete_marker_replication {
      status = "Enabled" # 삭제 마커 복제
    }

    filter {
      prefix = "/"
    }
  }
}
