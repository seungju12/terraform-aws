### 지역 변수 정의 ###
locals {
  id = data.aws_region.current.name == var.region_1 ? "region1-to-region2" : "region2-to-region1"
  regions_buckets = {
    "${var.region_1}" = {
      admin = {
        bucket_id = var.admin_1_id,
        dest_arn  = var.admin_2_arn
      },
      image = {
        bucket_id = var.image_1_id,
        dest_arn  = var.image_2_arn
      },
      md = {
        bucket_id = var.md_1_id,
        dest_arn  = var.md_2_arn
      }
    }
    "${var.region_2}" = {
      admin = {
        bucket_id = var.admin_2_id,
        dest_arn  = var.admin_1_arn
      },
      image = {
        bucket_id = var.image_2_id,
        dest_arn  = var.image_1_arn
      },
      md = {
        bucket_id = var.md_2_id,
        dest_arn  = var.md_1_arn
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
