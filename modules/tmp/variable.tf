variable "vpc_id" {
  type = string
}

variable "alb-sg_id" {
  type = string
}

variable "subnet_id" {
  type = list(string)
}
