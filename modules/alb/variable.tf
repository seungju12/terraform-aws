variable "vpc_id" {
  type = string
}

variable "subnet_id" {
  type = list(string)
}

variable "certificate_arn" {
  default = {
    ap-northeast-2 = "arn:aws:acm:ap-northeast-2:339712817209:certificate/b99756a1-8f7c-48f3-93b7-1496851b4edf"
    #ap-northeast-3 = "arn:aws:acm:ap-northeast-3:339712817209:certificate/a1fee5dc-0a56-4906-aae6-d30dced3fcb6"
  }
}