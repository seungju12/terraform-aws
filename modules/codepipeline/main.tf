### 파이프라인의 아티팩트를 저장할 S3의 버킷 이름을 중복되지 않게 생성하기 위해 랜덤 숫자 생성 ###
resource "random_integer" "random_number" {
  min = 100
  max = 99999999
}

### 
resource "aws_s3_bucket" "artifact_store" {
  bucket = "codepipeline-ap-northeast-2-${random_integer.random_number.result}"
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.artifact_store.bucket
  
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_codestarconnections_connection" "github" {
  name = "github-connection"
  provider_type = "GitHub"
}

resource "aws_codepipeline" "pipeline" {
  name = "pipeline-admin"
  role_arn = var.codepipeline_role_arn
  pipeline_type = "V2"
  execution_mode = "QUEUED"

  artifact_store {
    location = aws_s3_bucket.artifact_store.bucket
    type = "S3"
  }

  stage {
    name = "Source"

    action {
      name = "Source"
      category = "Source"
      owner = "AWS"
      provider = "CodeStarSourceConnection"
      version = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn = aws_codestarconnections_connection.github.arn
        FullRepositoryId = "sungmin-choi/blog_admin"
        BranchName = "main"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name = "Build"
      category = "Build"
      owner = "AWS"
      provider = "CodeBuild"
      version = "1"
      input_artifacts = ["source_output"]
      output_artifacts = ["build_output"]
      
      configuration = {
        ProjectName = "build-admin"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name = "Deploy"
      category = "Deploy"
      owner = "AWS"
      provider = "S3"
      version = "1"
      input_artifacts = ["build_output"]

      configuration = {
        BucketName = aws_s3_bucket.artifact_store.bucket
        Extract = true
      }
    }
  }
}