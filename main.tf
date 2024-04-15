### 프로바이더 ###
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    random = {
      source = "hashicorp/random"
    }
    archive = {
      source = "hashicorp/archive"
    }
  }
}

provider "aws" {
  region     = local.region_1
  access_key = var.access_key
  secret_key = var.secret_key
}

provider "aws" {
  alias      = "r2"
  region     = local.region_2
  access_key = var.access_key
  secret_key = var.secret_key

}

### 지역 변수 정의 ###
locals {
  region_1 = "ap-northeast-2" # 사용할 리전 1
  region_2 = "ap-northeast-1" # 사용할 리전 2
  blog     = "qwerblog"       # 사용할 블로그 이름 / S3 버킷의 이름이 전세계적으로 고유해야 하므로 바꿔줘야 함.
  domain   = "qwerblog.com"   # 사용할 도메인 이름
}


##################### VPC, EC2 #####################



### VPC 생성 ###
module "create_vpc" {
  source   = "./modules/vpc"
  region_1 = local.region_1
  region_2 = local.region_2
}

module "create_vpc_2" {
  source   = "./modules/vpc"
  region_1 = local.region_1
  region_2 = local.region_2
  providers = {
    aws = aws.r2
  }
}

### ALB 생성 ###
module "create_alb" {
  source          = "./modules/alb"
  certificate_arn = var.region_1_acm
  vpc_id          = module.create_vpc.vpc_id
  subnet_id       = module.create_vpc.subnet_id
}

module "create_alb_2" {
  source          = "./modules/alb"
  certificate_arn = var.region_2_acm
  vpc_id          = module.create_vpc_2.vpc_id
  subnet_id       = module.create_vpc_2.subnet_id
  providers = {
    aws = aws.r2
  }
}

### 시작 템플릿 생성 ###
module "create_tmp" {
  source    = "./modules/tmp"
  vpc_id    = module.create_vpc.vpc_id
  subnet_id = module.create_vpc.subnet_id
  alb-sg_id = module.create_alb.alb-sg_id
}

module "create_tmp_2" {
  source    = "./modules/tmp"
  vpc_id    = module.create_vpc_2.vpc_id
  subnet_id = module.create_vpc_2.subnet_id
  alb-sg_id = module.create_alb_2.alb-sg_id
  providers = {
    aws = aws.r2
  }
}

### ASG 생성 ###
module "create_asg" {
  source     = "./modules/asg"
  vpc_id     = module.create_vpc.vpc_id
  subnet_id  = module.create_vpc.subnet_id
  blog_tmp   = module.create_tmp.blog_tmp
  target_arn = module.create_alb.target_arn
}

module "create_asg_2" {
  source     = "./modules/asg"
  vpc_id     = module.create_vpc_2.vpc_id
  subnet_id  = module.create_vpc_2.subnet_id
  blog_tmp   = module.create_tmp_2.blog_tmp
  target_arn = module.create_alb_2.target_arn
  providers = {
    aws = aws.r2
  }
}


##################### S3 #####################


### 어드민 페이지 S3 생성 ###
module "create_admin_s3" {
  source                               = "./modules/s3-admin"
  blog                                 = local.blog
  region                               = local.region_1
  lambda_cloudfront_ttl_expired_arn    = module.create_lambda.lambda_cloudfront_ttl_expired_arn
  lambda_cloudfront_ttl_expired_2_arn  = module.create_lambda_2.lambda_cloudfront_ttl_expired_arn
  lambda_cloudfront_ttl_expired_name   = module.create_lambda.lambda_cloudfront_ttl_expired_name
  lambda_cloudfront_ttl_expired_2_name = module.create_lambda_2.lambda_cloudfront_ttl_expired_name
}

module "create_admin_s3_2" {
  source                               = "./modules/s3-admin"
  blog                                 = local.blog
  region                               = local.region_1
  lambda_cloudfront_ttl_expired_arn    = module.create_lambda.lambda_cloudfront_ttl_expired_arn
  lambda_cloudfront_ttl_expired_2_arn  = module.create_lambda_2.lambda_cloudfront_ttl_expired_arn
  lambda_cloudfront_ttl_expired_name   = module.create_lambda.lambda_cloudfront_ttl_expired_name
  lambda_cloudfront_ttl_expired_2_name = module.create_lambda_2.lambda_cloudfront_ttl_expired_name
  providers = {
    aws = aws.r2
  }
}

### 이미지 S3 생성 ###
module "create_image_s3" {
  blog   = local.blog
  region = local.region_1
  source = "./modules/s3-image"
}

module "create_image_s3_2" {
  source = "./modules/s3-image"
  blog   = local.blog
  region = local.region_1
  providers = {
    aws = aws.r2
  }
}

### md 파일 S3 생성 ###
module "create_md_s3" {
  source = "./modules/s3-md"
  blog   = local.blog
  region = local.region_1
}

module "create_md_s3_2" {
  source = "./modules/s3-md"
  blog   = local.blog
  region = local.region_1
  providers = {
    aws = aws.r2
  }
}

### IAM 역할 생성 ###
module "create_iam_role" {
  source      = "./modules/s3-iam"
  admin_1_arn = module.create_admin_s3.admin_1_arn
  admin_2_arn = module.create_admin_s3_2.admin_2_arn
  image_1_arn = module.create_image_s3.image_1_arn
  image_2_arn = module.create_image_s3_2.image_2_arn
  md_1_arn    = module.create_md_s3.md_1_arn
  md_2_arn    = module.create_md_s3_2.md_2_arn
}

### S3 복제 규칙 추가 ###
module "create_s3_replica_rule" {
  source               = "./modules/s3-replica"
  region_1             = local.region_1
  region_2             = local.region_2
  replication_role_arn = module.create_iam_role.replication_role_arn
  admin_1_id           = module.create_admin_s3.admin_1_id
  admin_2_id           = module.create_admin_s3_2.admin_2_id
  admin_1_arn          = module.create_admin_s3.admin_1_arn
  admin_2_arn          = module.create_admin_s3_2.admin_2_arn
  image_1_id           = module.create_image_s3.image_1_id
  image_2_id           = module.create_image_s3_2.image_2_id
  image_1_arn          = module.create_image_s3.image_1_arn
  image_2_arn          = module.create_image_s3_2.image_2_arn
  md_1_id              = module.create_md_s3.md_1_id
  md_2_id              = module.create_md_s3_2.md_2_id
  md_1_arn             = module.create_md_s3.md_1_arn
  md_2_arn             = module.create_md_s3_2.md_2_arn
  depends_on = [
    module.create_admin_s3,
    module.create_image_s3,
    module.create_md_s3
  ]
}

module "create_s3_replica_rule_2" {
  source               = "./modules/s3-replica"
  region_1             = local.region_1
  region_2             = local.region_2
  replication_role_arn = module.create_iam_role.replication_role_arn
  admin_1_id           = module.create_admin_s3.admin_1_id
  admin_2_id           = module.create_admin_s3_2.admin_2_id
  admin_1_arn          = module.create_admin_s3.admin_1_arn
  admin_2_arn          = module.create_admin_s3_2.admin_2_arn
  image_1_id           = module.create_image_s3.image_1_id
  image_2_id           = module.create_image_s3_2.image_2_id
  image_1_arn          = module.create_image_s3.image_1_arn
  image_2_arn          = module.create_image_s3_2.image_2_arn
  md_1_id              = module.create_md_s3.md_1_id
  md_2_id              = module.create_md_s3_2.md_2_id
  md_1_arn             = module.create_md_s3.md_1_arn
  md_2_arn             = module.create_md_s3_2.md_2_arn
  depends_on = [
    module.create_admin_s3_2,
    module.create_image_s3_2,
    module.create_md_s3_2
  ]
  providers = {
    aws = aws.r2
  }
}
/*
### S3 멀티 리전 액세스 포인트 생성 ###
module "create_admin_mrap" {
  source         = "./modules/s3-mrap"
  admin_1_id = module.create_admin_s3.admin_1_id
  admin_2_id = module.create_admin_s3_2.admin_2_id
  image_1_id = module.create_image_s3.image_1_id
  image_2_id = module.create_image_s3_2.image_2_id
  md_1_id    = module.create_md_s3.md_1_id
  md_2_id    = module.create_md_s3_2.md_2_id
}
*/

#####################       Admin S3 CI/CD 파이프라인         #####################
##################### 다른 계정에선 깃허브 인증이 불가하니 PASS #####################


### IAM 역할 생성 ###
module "create_code_role" {
  source = "./modules/code-iam"
}

### CodeBuild 프로젝트 생성 ###
module "create_codebuild" {
  source             = "./modules/codebuild"
  codebuild_role_arn = module.create_code_role.codebuild_role_arn
  admin_1_bucket     = module.create_admin_s3.admin_1_bucket
  admin_1_id         = module.create_admin_s3.admin_1_id
}

### IAM 역할에 정책 추가 ###
module "create_code_role_policy" {
  source                 = "./modules/code-iam2"
  admin_1_arn            = module.create_admin_s3.admin_1_arn
  codebuild_name         = module.create_codebuild.codebuild_name
  codebuild_role_name    = module.create_code_role.codebuild_role_name
  codepipeline_role_name = module.create_code_role.codepipeline_role_name
}

### PipeLine 생성 ###
module "create_codepipeline" {
  source                = "./modules/codepipeline"
  codebuild_name        = module.create_codebuild.codebuild_name
  codepipeline_role_arn = module.create_code_role.codepipeline_role_arn
}
### 콘솔에서 깃허브 연결 승인 직접 해줘야 함 ###


##################### Lambda / API Gateway #####################


### Lambda IAM 역할 생성 ###
module "create_lambda_role" {
  source = "./modules/lambda-iam"
}

### Lambda 함수 생성 ###
module "create_lambda" {
  source      = "./modules/lambda"
  lambda_role = module.create_lambda_role.lambda_role

}

module "create_lambda_2" {
  source      = "./modules/lambda"
  lambda_role = module.create_lambda_role.lambda_role
  providers = {
    aws = aws.r2
  }
}

### API Gateway 생성
module "create_api-gateway" {
  source                            = "./modules/api-gateway"
  lambda_get_blog_item_name         = module.create_lambda.lambda_get_blog_item_name
  lambda_get_blog_item_arn          = module.create_lambda.lambda_get_blog_item_arn
  lambda_get_blog_items_name        = module.create_lambda.lambda_get_blog_items_name
  lambda_get_blog_items_arn         = module.create_lambda.lambda_get_blog_items_arn
  lambda_get_s3_signed_url_name     = module.create_lambda.lambda_get_s3_signed_url_name
  lambda_get_s3_signed_url_arn      = module.create_lambda.lambda_get_s3_signed_url_arn
  lambda_post_blog_to_dynamodb_name = module.create_lambda.lambda_post_blog_to_dynamodb_name
  lambda_post_blog_to_dynamodb_arn  = module.create_lambda.lambda_post_blog_to_dynamodb_arn
  region_1_acm                      = var.region_1_acm
  region_2_acm                      = var.region_2_acm
  region                            = local.region_1
}

module "create_api-gateway_2" {
  source                            = "./modules/api-gateway"
  lambda_get_blog_item_name         = module.create_lambda.lambda_get_blog_item_name
  lambda_get_blog_item_arn          = module.create_lambda.lambda_get_blog_item_arn
  lambda_get_blog_items_name        = module.create_lambda.lambda_get_blog_items_name
  lambda_get_blog_items_arn         = module.create_lambda.lambda_get_blog_items_arn
  lambda_get_s3_signed_url_name     = module.create_lambda.lambda_get_s3_signed_url_name
  lambda_get_s3_signed_url_arn      = module.create_lambda.lambda_get_s3_signed_url_arn
  lambda_post_blog_to_dynamodb_name = module.create_lambda.lambda_post_blog_to_dynamodb_name
  lambda_post_blog_to_dynamodb_arn  = module.create_lambda.lambda_post_blog_to_dynamodb_arn
  region_1_acm                      = var.region_1_acm
  region_2_acm                      = var.region_2_acm
  region                            = local.region_1
  providers = {
    aws = aws.r2
  }
}


##################### Route 53 / CloudFront #####################


### CloudFront ###
module "cloudfront" {
  source                              = "./modules/cloudfront"
  admin_1_bucket_regional_domain_name = module.create_admin_s3.admin_bucket_regional_domain_name
  admin_2_bucket_regional_domain_name = module.create_admin_s3_2.admin_bucket_regional_domain_name
  admin_1_id                          = module.create_admin_s3.admin_1_id
  admin_2_id                          = module.create_admin_s3_2.admin_2_id
  us_acm                              = var.us_acm
}


### Route53 ###
module "route53" {
  source            = "./modules/route53"
  domain            = local.domain
  region_1          = local.region_1
  region_2          = local.region_2
  domain_name1      = module.cloudfront.domain_name1
  domain_name2      = module.cloudfront.domain_name2
  zone_id1          = module.cloudfront.zone_id1
  zone_id2          = module.cloudfront.zone_id2
  api_1_id          = module.create_api-gateway.api_id
  api_2_id          = module.create_api-gateway_2.api_id
  api_domain_name   = module.create_api-gateway.api_domain_name
  api_domain_name_2 = module.create_api-gateway_2.api_domain_name
  api_zone_id       = module.create_api-gateway.api_zone_id
  api_zone_id_2     = module.create_api-gateway_2.api_zone_id
}