### aws 프로바이더 ###
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "ap-northeast-2"
}

provider "aws" {
  alias  = "osaka"
  region = "ap-northeast-3"
}


##################### region = seoul #####################



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
  source    = ".\\modules\\tmp"
  vpc_id    = module.create_vpc.vpc_id
  subnet_id = module.create_vpc.subnet_id
  alb-sg_id = module.create_alb.alb-sg_id
}

### ASG 생성 모듈 ###
module "create_asg" {
  source     = ".\\modules\\asg"
  vpc_id     = module.create_vpc.vpc_id
  subnet_id  = module.create_vpc.subnet_id
  blog_tmp   = module.create_tmp.blog_tmp
  target_arn = module.create_alb.target_arn
  depends_on = [module.create_tmp, module.create_alb]
}



##################### region = osaka #####################



### VPC 생성 모듈 ###
module "create_vpc_osaka" {
  source = ".\\modules\\vpc"
  providers = {
    aws = aws.osaka
  }
}

### ALB 생성 모듈 ###
module "create_alb_osaka" {
  source     = ".\\modules\\alb"
  vpc_id     = module.create_vpc_osaka.vpc_id
  subnet_id  = module.create_vpc_osaka.subnet_id
  depends_on = [module.create_vpc_osaka]
  providers = {
    aws = aws.osaka
  }
}

### 시작 템플릿 생성 모듈 ###
module "create_tmp_osaka" {
  source    = ".\\modules\\tmp"
  vpc_id    = module.create_vpc_osaka.vpc_id
  subnet_id = module.create_vpc_osaka.subnet_id
  alb-sg_id = module.create_alb_osaka.alb-sg_id
  providers = {
    aws = aws.osaka
  }
}

### ASG 생성 모듈 ###
module "create_asg_osaka" {
  source     = ".\\modules\\asg"
  vpc_id     = module.create_vpc_osaka.vpc_id
  subnet_id  = module.create_vpc_osaka.subnet_id
  blog_tmp   = module.create_tmp_osaka.blog_tmp
  target_arn = module.create_alb_osaka.target_arn
  depends_on = [module.create_alb_osaka, module.create_tmp_osaka]
  providers = {
    aws = aws.osaka
  }
}

