### OAI 생성 ###
resource "aws_cloudfront_origin_access_identity" "oai" {

}

### CloudFront 배포 생성 ###
resource "aws_cloudfront_distribution" "admin" {
  origin {
    domain_name = var.admin_1_bucket_regional_domain_name
    origin_id   = "S3-${var.admin_1_id}"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }

  enabled         = true
  is_ipv6_enabled = true
  price_class     = "PriceClass_All" # 북미, 유럽, 아시아, 중동, 아프리카 엣지 로케이션 사용

  default_cache_behavior {
    target_origin_id       = "S3-${var.admin_1_id}"
    viewer_protocol_policy = "redirect-to-https" # HTTPS 리다이렉션
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  viewer_certificate {
    acm_certificate_arn      = var.us_acm
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2018"
  }

  custom_error_response {
    error_code            = 404
    response_page_path    = "/404.html"
    response_code         = 404
    error_caching_min_ttl = 300
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}

resource "aws_cloudfront_distribution" "admin_2" {
  origin {
    domain_name = var.admin_2_bucket_regional_domain_name
    origin_id   = "S3-${var.admin_2_id}"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }

  enabled         = true
  is_ipv6_enabled = true
  price_class     = "PriceClass_All"

  default_cache_behavior {
    target_origin_id       = "S3-${var.admin_2_id}"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  viewer_certificate {
    acm_certificate_arn      = var.us_acm
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2018"
  }

  custom_error_response {
    error_code            = 404
    response_page_path    = "/404.html"
    response_code         = 404
    error_caching_min_ttl = 300
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}