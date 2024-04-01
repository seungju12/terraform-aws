terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
    }
  }
}

module "create_vpc" {
  source = ".\\modules\\terraform-aws-vpc"
}
