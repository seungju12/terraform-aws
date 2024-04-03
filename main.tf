### aws 프로바이더 ###
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

### VPC 생성 모듈 ###
module "create_vpc" {
  source = ".\\modules\\vpc"
}

### ALB 생성 모듈 ###
module "create_alb" {
  source     = ".\\modules\\alb"
  vpc_id     = module.create_vpc.vpc_id
  subnet_id  = module.create_vpc.subnet_id
  depends_on = [module.create_vpc]
}

### 시작 템플릿 생성 모듈 ###
module "create_tmp" {
  source     = ".\\modules\\tmp"
  vpc_id     = module.create_vpc.vpc_id
  subnet_id  = module.create_vpc.subnet_id
  alb-sg_id  = module.create_alb.alb-sg_id
  depends_on = [module.create_alb]
}

### ASG 생성 모듈 ###
module "create_asg" {
  source     = ".\\modules\\asg"
  vpc_id     = module.create_vpc.vpc_id
  subnet_id  = module.create_vpc.subnet_id
  blog_tmp   = module.create_tmp.blog_tmp
  target_arn    = module.create_alb.target_arn
  depends_on = [module.create_tmp]
}