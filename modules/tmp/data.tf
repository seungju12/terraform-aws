data "aws_ami" "blog-ami" {
  owners      = ["339712817209"]
  most_recent = true

  filter {
    name   = "name"
    values = ["blog-base-image-v2"]
  }
}