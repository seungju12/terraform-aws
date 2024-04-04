### S3 복제를 위한 IAM Role 생성 ###
resource "aws_iam_role" "replication" {
  name = "s3-replication-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

### S3 복제를 위한 IAM 정책 생성 ###
resource "aws_iam_policy" "replication" {
  name = "s3-replication-policy"
  policy = data.aws_iam_policy_document.replication.json
}

### IAM Role과 정책 연결 ###
resource "aws_iam_role_policy_attachment" "replication" {
  role = aws_iam_role.replication.name
  policy_arn = aws_iam_policy.replication.arn
}