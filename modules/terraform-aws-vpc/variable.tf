variable "regions" {
  type = map(string)
  default = {
    "ap-northeast-2" = "10.2.0.0/16"
    "ap-northeast-3" = "10.3.0.0/16"
  }
}

variable "seoul-subnets" {
  type = map(string)
  default = {
    "ap-northeast-2a" = "10.2.1.0/24"
    "ap-northeast-2c" = "10.2.3.0/24"
  }
}

variable "osaka-subnets" {
  type = map(string)
  default = {
    "ap-northeast-3a" = "10.3.1.0/24"
    "ap-northeast-3c" = "10.3.3.0/24"
  }
}