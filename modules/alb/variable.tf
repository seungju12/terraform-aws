variable "vpc_id" {
  type = string
}

variable "subnet_id" {
  type = list(string)
}

variable "certificate_arn" {
  type = string
}