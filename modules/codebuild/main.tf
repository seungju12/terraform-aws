### CodeBuild 프로젝트 생성 ###
resource "aws_codebuild_project" "build" {
  name = "build-admin"
  service_role = var.codebuild_role_arn

  source {
    type = "GITHUB"
    location = "https://github.com/sungmin-choi/blog_admin.git"
    git_clone_depth = 1 # 최신 커밋만 불러옴
    buildspec = "buildspec.yml" # 소스 내 buildspec.yml 참조
  }

  source_version = "main" # main 브랜치

  environment {
    compute_type = "BUILD_GENERAL1_SMALL" # vCPU 2개, RAM 3기가
    image = "aws/codebuild/amazonlinux2-x86_64-standard:5.0" # aws 제공 이미지
    type = "LINUX_CONTAINER" # 리눅스 컨테이너 사용
    image_pull_credentials_type = "CODEBUILD" # CODEBUILD의 자격증명으로 이미지 사용
  }

  artifacts {
    type = "S3"
    location = var.admin_seoul_bucket # 빌드한 결과물을 서울의 admin S3 버킷에 저장
  }

  logs_config {
    cloudwatch_logs {
      group_name = "build-log" # 로그 그룹 이름
      stream_name = "build-stream" # 로그 스트림 이름
    }

    s3_logs {
      status = "ENABLED"
      location = "${var.admin_seoul_id}/build-log" # 지정된 경로에 로그 저장
    }
  }
}