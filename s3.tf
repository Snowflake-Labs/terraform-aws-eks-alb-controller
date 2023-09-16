resource "aws_s3_bucket" "logs_bucket" {
  count = var.create_logs_bucket == true ? 1 : 0

  bucket = "${var.module_prefix}-logs-bucket"
}

resource "aws_s3_bucket_ownership_controls" "logs_bucket_ownership" {
  count = var.create_logs_bucket == true ? 1 : 0

  bucket = aws_s3_bucket.logs_bucket[0].id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "logs_bucket_acl" {
  count = var.create_logs_bucket == true ? 1 : 0

  bucket = aws_s3_bucket.logs_bucket[0].id
  acl    = "private"
  depends_on = [aws_s3_bucket_ownership_controls.logs_bucket_ownership[0]]
}

resource "aws_s3_bucket_policy" "allow_access_from_eks" {
  bucket = aws_s3_bucket.logs_bucket[0].id
  policy = data.aws_iam_policy_document.allow_access_from_eks.json
}

data "aws_iam_policy_document" "allow_access_from_eks" {
  statement {
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.lb_controller_role.arn]
    }

    actions = [
      "s3:PubObject",
    ]

    resources = [aws_s3_bucket.logs_bucket[0].arn]
  }
}
