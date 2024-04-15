### admin S3 멀티 리전 액세스 포인트 생성 ###
resource "aws_s3control_multi_region_access_point" "admin-mrap" {
  details {
    name = "admin-mrap"

    region {
      bucket = var.admin_1_id
    }

    region {
      bucket = var.admin_2_id
    }

    public_access_block { # 퍼블릭 액세스 허용
      block_public_acls       = false
      block_public_policy     = false
      ignore_public_acls      = false
      restrict_public_buckets = false
    }
  }
}

### 정책 적용 ###
resource "aws_s3control_multi_region_access_point_policy" "admin-policy" {
  details {
    name = aws_s3control_multi_region_access_point.admin-mrap.details[0].name
    policy = templatefile("${path.module}/s3mrap-policy.json.tpl", {
      alias      = aws_s3control_multi_region_access_point.admin-mrap.alias,
      current_id = data.aws_caller_identity.current.account_id
    })
  }
}

### image S3 멀티 리전 액세스 포인트 생성 ###
resource "aws_s3control_multi_region_access_point" "image-mrap" {
  details {
    name = "image-mrap"

    region {
      bucket = var.image_1_id
    }

    region {
      bucket = var.image_2_id
    }

    public_access_block { # 퍼블릭 액세스 허용
      block_public_acls       = false
      block_public_policy     = false
      ignore_public_acls      = false
      restrict_public_buckets = false
    }
  }
}

### 정책 적용 ###
resource "aws_s3control_multi_region_access_point_policy" "image-policy" {
  details {
    name = aws_s3control_multi_region_access_point.image-mrap.details[0].name
    policy = templatefile("${path.module}/s3mrap-policy.json.tpl", {
      alias      = aws_s3control_multi_region_access_point.image-mrap.alias,
      current_id = data.aws_caller_identity.current.account_id
    })
  }
}

### md S3 멀티 리전 액세스 포인트 생성 ###
resource "aws_s3control_multi_region_access_point" "md-mrap" {
  details {
    name = "md-mrap"

    region {
      bucket = var.md_1_id
    }

    region {
      bucket = var.md_2_id
    }

    public_access_block { # 퍼블릭 액세스 허용
      block_public_acls       = false
      block_public_policy     = false
      ignore_public_acls      = false
      restrict_public_buckets = false
    }
  }
}

### 정책 적용 ###
resource "aws_s3control_multi_region_access_point_policy" "md-policy" {
  details {
    name = aws_s3control_multi_region_access_point.md-mrap.details[0].name
    policy = templatefile("${path.module}/s3mrap-policy.json.tpl", {
      alias      = aws_s3control_multi_region_access_point.md-mrap.alias,
      current_id = data.aws_caller_identity.current.account_id
    })
  }
}