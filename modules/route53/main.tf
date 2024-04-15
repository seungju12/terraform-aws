### 호스팅 영역 생성 ###
resource "aws_route53_zone" "domain" {
  name = var.domain
}

### 어드민 페이지 A 레코드 생성 ###
resource "aws_route53_record" "admin" {
  zone_id        = aws_route53_zone.domain.id
  name           = "admin1.${var.domain}"
  type           = "A"
  set_identifier = "admin1"

  geoproximity_routing_policy {
    aws_region = var.region_1
  }

  alias {
    name                   = var.domain_name1
    zone_id                = var.zone_id1
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "admin_2" {
  zone_id        = aws_route53_zone.domain.id
  name           = "admin1.${var.domain}"
  type           = "A"
  set_identifier = "admin2"

  geoproximity_routing_policy {
    aws_region = var.region_2
  }

  alias {
    name                   = var.domain_name2
    zone_id                = var.zone_id2
    evaluate_target_health = false
  }
}

### API 레코드 생성 ###
resource "aws_route53_record" "api" {
  zone_id        = aws_route53_zone.domain.id
  name           = "api1.${var.domain}"
  type           = "A"
  set_identifier = "geo1"

  geoproximity_routing_policy {
    aws_region = var.region_1
  }

  alias {
    name                   = var.api_domain_name
    zone_id                = var.api_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "api_2" {
  zone_id        = aws_route53_zone.domain.id
  name           = "api1.${var.domain}"
  type           = "A"
  set_identifier = "geo2"

  geoproximity_routing_policy {
    aws_region = var.region_2
  }

  alias {
    name                   = var.api_domain_name_2
    zone_id                = var.api_zone_id_2
    evaluate_target_health = true
  }
}