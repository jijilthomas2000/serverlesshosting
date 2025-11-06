resource "aws_dynamodb_table" "visitor" {
  name         = "visitor_count_${var.environment}"
  billing_mode = "PAY_PER_REQUEST"

  hash_key = "id"

  attribute {
    name = "id"
    type = "S"
  }
}
