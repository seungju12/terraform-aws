### CodeBuild 정책 생성 ###
resource "aws_iam_policy" "codebuild" {
  name   = "codebuild-policy"
  policy = data.aws_iam_policy_document.codebuild.json
}

### CodePipeLine 정책 생성 ###
resource "aws_iam_policy" "codepipeline" {
  name   = "codepipeline-policy"
  policy = data.aws_iam_policy_document.codepipeline.json
}

### CodeBuild 정책 연결 ###
resource "aws_iam_role_policy_attachment" "codebuild" {
  role       = var.codebuild_role_name
  policy_arn = aws_iam_policy.codebuild.arn
}

### CodePipeLine 정책 연결 ###
resource "aws_iam_role_policy_attachment" "codepipeline" {
  role       = var.codepipeline_role_name
  policy_arn = aws_iam_policy.codepipeline.arn
}