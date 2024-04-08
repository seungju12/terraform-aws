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

/*

### VPC 생성 모듈 ###
module "create_vpc" {
  source = "./modules/vpc"
}

### ALB 생성 모듈 ###
module "create_alb" {
  source     = "./modules/alb"
  vpc_id     = module.create_vpc.vpc_id
  subnet_id  = module.create_vpc.subnet_id
}

### 시작 템플릿 생성 모듈 ###
module "create_tmp" {
  source    = "./modules/tmp"
  vpc_id    = module.create_vpc.vpc_id
  subnet_id = module.create_vpc.subnet_id
  alb-sg_id = module.create_alb.alb-sg_id
}

### ASG 생성 모듈 ###
module "create_asg" {
  source     = "./modules/asg"
  vpc_id     = module.create_vpc.vpc_id
  subnet_id  = module.create_vpc.subnet_id
  blog_tmp   = module.create_tmp.blog_tmp
  target_arn = module.create_alb.target_arn
}



##################### region = osaka #####################



### VPC 생성 모듈 ###
module "create_vpc_osaka" {
  source = "./modules/vpc"
  providers = {
    aws = aws.osaka
  }
}

### ALB 생성 모듈 ###
module "create_alb_osaka" {
  source     = "./modules/alb"
  vpc_id     = module.create_vpc_osaka.vpc_id
  subnet_id  = module.create_vpc_osaka.subnet_id
  providers = {
    aws = aws.osaka
  }
}

### 시작 템플릿 생성 모듈 ###
module "create_tmp_osaka" {
  source    = "./modules/tmp"
  vpc_id    = module.create_vpc_osaka.vpc_id
  subnet_id = module.create_vpc_osaka.subnet_id
  alb-sg_id = module.create_alb_osaka.alb-sg_id
  providers = {
    aws = aws.osaka
  }
}

### ASG 생성 모듈 ###
module "create_asg_osaka" {
  source     = "./modules/asg"
  vpc_id     = module.create_vpc_osaka.vpc_id
  subnet_id  = module.create_vpc_osaka.subnet_id
  blog_tmp   = module.create_tmp_osaka.blog_tmp
  target_arn = module.create_alb_osaka.target_arn
  providers = {
    aws = aws.osaka
  }
}
*/


##################### s3 #####################



module "create_admin_s3" {
  source = "./modules/s3-admin"
}

module "create_admin_s3_osaka" {
  source = "./modules/s3-admin"
  providers = {
    aws = aws.osaka
  }
}

module "create_image_s3" {
  source = "./modules/s3-image"
}

module "create_image_s3_osaka" {
  source = "./modules/s3-image"
  providers = {
    aws = aws.osaka
  }
}

module "create_md_s3" {
  source = "./modules/s3-md"
}

module "create_md_s3_osaka" {
  source = "./modules/s3-md"
  providers = {
    aws = aws.osaka
  }
}

module "create_iam_role" {
  source = "./modules/s3-iam"
  admin_seoul_arn = module.create_admin_s3.admin_seoul_arn
  admin_osaka_arn = module.create_admin_s3_osaka.admin_osaka_arn
  image_seoul_arn = module.create_image_s3.image_seoul_arn
  image_osaka_arn = module.create_image_s3_osaka.image_osaka_arn
  md_seoul_arn = module.create_md_s3.md_seoul_arn
  md_osaka_arn = module.create_md_s3_osaka.md_osaka_arn
}

module "create_s3_replica_rule" {
  source = "./modules/s3-replica"
  replication_role_arn = module.create_iam_role.replication_role_arn
  admin_seoul_id = module.create_admin_s3.admin_seoul_id
  admin_osaka_id = module.create_admin_s3_osaka.admin_osaka_id
  admin_seoul_arn = module.create_admin_s3.admin_seoul_arn
  admin_osaka_arn = module.create_admin_s3_osaka.admin_osaka_arn
  image_seoul_id = module.create_image_s3.image_seoul_id
  image_osaka_id = module.create_image_s3_osaka.image_osaka_id
  image_seoul_arn = module.create_image_s3.image_seoul_arn
  image_osaka_arn = module.create_image_s3_osaka.image_osaka_arn
  md_seoul_id = module.create_md_s3.md_seoul_id
  md_osaka_id = module.create_md_s3_osaka.md_osaka_id
  md_seoul_arn = module.create_md_s3.md_seoul_arn
  md_osaka_arn = module.create_md_s3_osaka.md_osaka_arn
  depends_on = [ 
    module.create_admin_s3,
    module.create_image_s3,
    module.create_md_s3
   ]
}

module "create_s3_replica_rule_osaka" {
  source = "./modules/s3-replica"
  replication_role_arn = module.create_iam_role.replication_role_arn
  admin_seoul_id = module.create_admin_s3.admin_seoul_id
  admin_osaka_id = module.create_admin_s3_osaka.admin_osaka_id
  admin_seoul_arn = module.create_admin_s3.admin_seoul_arn
  admin_osaka_arn = module.create_admin_s3_osaka.admin_osaka_arn
  image_seoul_id = module.create_image_s3.image_seoul_id
  image_osaka_id = module.create_image_s3_osaka.image_osaka_id
  image_seoul_arn = module.create_image_s3.image_seoul_arn
  image_osaka_arn = module.create_image_s3_osaka.image_osaka_arn
  md_seoul_id = module.create_md_s3.md_seoul_id
  md_osaka_id = module.create_md_s3_osaka.md_osaka_id
  md_seoul_arn = module.create_md_s3.md_seoul_arn
  md_osaka_arn = module.create_md_s3_osaka.md_osaka_arn
  depends_on = [ 
    module.create_admin_s3_osaka,
    module.create_image_s3_osaka,
    module.create_md_s3_osaka
   ]
  providers = {
    aws = aws.osaka
  }
}

module "create_admin_mrap" {
  source = "./modules/s3-mrap"
  admin_seoul_id = module.create_admin_s3.admin_seoul_id
  admin_osaka_id = module.create_admin_s3_osaka.admin_osaka_id
  image_seoul_id = module.create_image_s3.image_seoul_id
  image_osaka_id = module.create_image_s3_osaka.image_osaka_id
  md_seoul_id = module.create_md_s3.md_seoul_id
  md_osaka_id = module.create_md_s3_osaka.md_osaka_id
}