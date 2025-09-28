resource "aws_s3_bucket" "lks_S3" {
  bucket = "lks-tf-test-bucket"
}

data "aws_iam_policy_document" "public_read" {
  statement {
    sid    = "PublicReadGetObject"
    effect = "Allow"
    
    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${aws_s3_bucket.lks_S3.arn}/*",
    ]
  }
}

//bucket policy
resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.lks_S3.id
  policy = data.aws_iam_policy_document.public_read.json
}

# Lifecycle Rule: Archive 30 hari, Delete permanen 1 tahun
resource "aws_s3_bucket_lifecycle_configuration" "lks_S3_lifecycle" {
  bucket = aws_s3_bucket.lks_S3.id

  rule {
    id     = "rule-1"
    status = "Enabled"

    filter {}

    transition {
      days          = 30
      storage_class = "GLACIER" 
    }

    expiration {
      days = 365 
    }
  }
}

//ACL
resource "aws_s3_bucket_ownership_controls" "lks_S3_acl" {
  bucket = aws_s3_bucket.lks_S3.id

  rule {
    object_ownership = "ObjectWriter"
  }
}

//public block
resource "aws_s3_bucket_public_access_block" "lks_S3_bpa" {
  bucket                  = aws_s3_bucket.lks_S3.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

//versioning
resource "aws_s3_bucket_versioning" "lks_S3_versioning" {
  bucket = aws_s3_bucket.lks_S3.id

  versioning_configuration {
    status = "Enabled"
  }
}