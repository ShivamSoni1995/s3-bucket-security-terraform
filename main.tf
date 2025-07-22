provider "aws" {
  region = "us-east-1"
}

# 1️⃣ Create the S3 bucket
resource "aws_s3_bucket" "my_secure_bucket" {
  bucket = "my-secure-bucket-1234567890" # Replace with a unique bucket name
}

# 2️⃣ IAM user (example)
resource "aws_iam_user" "read_only_user" {
  name = "my-readonly-user"
}

# 3️⃣ Create the policy document
data "aws_iam_policy_document" "allow_read_only_access" {
  statement {
    principals {
      type        = "AWS"
      identifiers = [aws_iam_user.read_only_user.arn]
    }

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.my_secure_bucket.arn,          # ListBucket applies to the bucket itself
      "${aws_s3_bucket.my_secure_bucket.arn}/*",   # GetObject applies to objects in the bucket
    ]
  }
}

# 4️⃣ Attach the bucket policy
resource "aws_s3_bucket_policy" "read_only_policy" {
  bucket = aws_s3_bucket.my_secure_bucket.id
  policy = data.aws_iam_policy_document.allow_read_only_access.json
}


