variable "vpc_id" {
  type = string
}

variable "subnet_id" {
  type = list(string)
}

variable "blog_tmp" {
  type = string
}

variable "target_arn" {
  type = string
}