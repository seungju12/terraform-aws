provider "aws" {
  alias = "seoul"
  region = "ap-northeast-2"
  access_key = "<ACCESS-KEY>"
  secret_key = "<SECRET_KEY>"
}

provider "aws" {
  alias = "osaka"
  region = "ap-northeast-3"
  access_key = "<ACCESS_KEY>"
  secret_key = "<SECRET_KEY>"
}