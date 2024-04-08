data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "replication" {
  statement {
    effect = "Allow"

    actions = [
      "s3:GetReplicationConfiguration",
      "s3:ListBucket"
    ]

    resources = [
      var.admin_seoul_arn,
      var.admin_osaka_arn,
      var.image_seoul_arn,
      var.image_osaka_arn,
      var.md_seoul_arn,
      var.md_osaka_arn
    ]
  }

  statement {
    effect = "Allow"
    
    actions = [
      "s3:GetObjectVersionForReplication",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectVersionTagging"
    ]

    resources = [
      "${var.admin_seoul_arn}/*",
      "${var.admin_osaka_arn}/*",
      "${var.image_seoul_arn}/*",
      "${var.image_osaka_arn}/*",
      "${var.md_seoul_arn}/*",
      "${var.md_osaka_arn}/*"
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:ReplicateObject",
      "s3:ReplicateDelete",
      "s3:ReplicateTags"
    ]

    resources = [
      "${var.admin_seoul_arn}/*",
      "${var.admin_osaka_arn}/*",
      "${var.image_seoul_arn}/*",
      "${var.image_osaka_arn}/*",
      "${var.md_seoul_arn}/*",
      "${var.md_osaka_arn}/*"
    ]
  }
}