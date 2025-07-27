provider "aws" {
  region = "ap-south-1"  # Use your region
}

resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = "devsecops-pipeline-artifacts-unique123"
  force_destroy = true
}

resource "aws_iam_role" "codebuild_role" {
  name = "codebuild-service-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "codebuild.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_codebuild_project" "this" {
  name          = "devsecops-build"
  service_role  = aws_iam_role.codebuild_role.arn
  artifacts {
    type = "NO_ARTIFACTS"
  }
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = true
  }
  source {
    type            = "GITHUB"
    location        = "https://github.com/<your-username>/<repo>.git"
    buildspec       = "app/buildspec.yml"
  }
}
