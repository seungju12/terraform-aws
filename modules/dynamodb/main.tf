resource "aws_dynamodb_table" "table" {
  name = "blogTable1"
  hash_key = "post_id"
  range_key = "date"
  billing_mode = "PAY_PER_REQUEST"
  
  attribute {
    name = "post_id"
    type = "S"
  }

  attribute {
    name = "date"
    type = "S"
  }

  replica {
    region_name = var.region_2
  }
}