terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

module "create_vpc" {
  source = ".\\modules\\vpc"
}

module "create_alb" {
  source     = ".\\modules\\alb"
  vpc_id     = module.create_vpc.vpc_id
  subnet_id  = module.create_vpc.subnet_id
  depends_on = [module.create_vpc]
}

module "create_tmp" {
  source     = ".\\modules\\tmp"
  vpc_id     = module.create_vpc.vpc_id
  subnet_id  = module.create_vpc.subnet_id
  alb-sg_id  = module.create_alb.alb-sg_id
  depends_on = [module.create_alb]
}

module "create_asg" {
  source     = ".\\modules\\asg"
  vpc_id     = module.create_vpc.vpc_id
  subnet_id  = module.create_vpc.subnet_id
  blog_tmp   = module.create_tmp.blog_tmp
  target_arn    = module.create_alb.target_arn
  depends_on = [module.create_tmp]
}