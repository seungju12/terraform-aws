### Lambda IAM Role 생성
resource "aws_iam_role" "lambda" {
  name = "lambda_iam_role"
  assume_role_policy = data.aws_iam_policy_document.role.json
}

### API Gateway 정책 연결 ###
resource "aws_iam_role_policy_attachment" "apigateway" {
  role = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonAPIGatewayInvokeFullAccess"
}

### DynamoDB 정책 연결 ###
resource "aws_iam_role_policy_attachment" "dynamodb" {
  role = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

### S3 정책 연결 ###
resource "aws_iam_role_policy_attachment" "S3" {
  role = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

### CloudFront 정책 연결 ###
resource "aws_iam_role_policy_attachment" "cloudfront" {
  role = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/CloudFrontFullAccess"
}

### CloudWatch 정책 연결 ###
resource "aws_iam_role_policy_attachment" "cloudwatch" {
  role = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
}
