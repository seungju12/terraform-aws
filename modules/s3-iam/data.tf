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
      var.admin_1_arn,
      var.admin_2_arn,
      var.image_1_arn,
      var.image_2_arn,
      var.md_1_arn,
      var.md_2_arn
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
      "${var.admin_1_arn}/*",
      "${var.admin_2_arn}/*",
      "${var.image_1_arn}/*",
      "${var.image_2_arn}/*",
      "${var.md_1_arn}/*",
      "${var.md_2_arn}/*"
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
      "${var.admin_1_arn}/*",
      "${var.admin_2_arn}/*",
      "${var.image_1_arn}/*",
      "${var.image_2_arn}/*",
      "${var.md_1_arn}/*",
      "${var.md_2_arn}/*"
    ]
  }
}