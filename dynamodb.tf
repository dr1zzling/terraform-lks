resource "aws_dynamodb_table" "lks_dynamodb" {
  name         = "lks-dynamodb"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"
  range_key    = "timestamp"

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "timestamp"
    type = "N"
  }

  tags = {
    Name = "lks-dynamodb"
  }
}
