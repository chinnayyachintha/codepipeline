#----------------
# Phase-1 CodePipeline
#----------------
resource "aws_codepipeline" "terraform_pipeline_phase1" {
  name           = "${var.project_name}-pipeline-phase1"
  role_arn       = var.codepipeline_role_arn
  pipeline_type  = "V2"
  execution_mode = "QUEUED"
  # tags           = var.tags

  artifact_store {
    location = var.s3_bucket_name
    type     = "S3"
    encryption_key {
      id   = var.kms_key_arn
      type = "KMS"
    }
  }

  trigger {
    provider_type = "CodeStarSourceConnection"
    git_configuration {
      source_action_name = "BitbucketSource"
      push {
        branches {
          includes = ["master"]
        }
        file_paths {
          includes = var.phase1_file_path
        }
      }
    }
  }

  stage {
    name = "Source"
    action {
      name             = "BitbucketSource"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["SourceOutput"]
      run_order        = 1
      configuration = {
        ConnectionArn    = var.bitbucket_connection_arn
        FullRepositoryId = var.source_repo_name
        BranchName       = var.source_repo_branch
        DetectChanges    = "true"
      }
    }
  }

  dynamic "stage" {
    for_each = var.stages_phase1
    content {
      name = "Stage-${stage.value["name"]}"
      action {
        name             = "Action-${stage.value["name"]}"
        category         = stage.value["category"]
        owner            = stage.value["owner"]
        provider         = stage.value["provider"]
        version          = "1"
        run_order        = index(var.stages_phase1, stage.value) + 2
        input_artifacts  = [stage.value["input_artifacts"]]
        output_artifacts = [stage.value["output_artifacts"]]
        configuration = stage.value["provider"] == "CodeBuild" ? {
          ProjectName = "${var.project_name}-${stage.value["name"]}"
        } : {}
      }
    }
  }
}

#-----------------
# Phase-2 CodePipeline
#-----------------
resource "aws_codepipeline" "terraform_pipeline_phase2" {
  name           = "${var.project_name}-pipeline-phase2"
  role_arn       = var.codepipeline_role_arn
  pipeline_type  = "V2"
  execution_mode = "QUEUED"
  # tags           = var.tags

  artifact_store {
    location = var.s3_bucket_name
    type     = "S3"

    encryption_key {
      id   = var.kms_key_arn
      type = "KMS"
    }
  }

  trigger {
    provider_type = "CodeStarSourceConnection"

    git_configuration {
      source_action_name = "BitbucketSource" # Must match the source action below
      push {
        branches {
          includes = ["master"]
        }
        file_paths {
          includes = var.phase2_file_path
        }
      }
    }
  }

  stage {
    name = "Source"

    action {
      name             = "BitbucketSource"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["SourceOutput"]
      run_order        = 1

      configuration = {
        ConnectionArn    = var.bitbucket_connection_arn
        FullRepositoryId = var.source_repo_name
        BranchName       = var.source_repo_branch
        DetectChanges    = "true"
      }
    }
  }

  dynamic "stage" {
    for_each = var.stages_phase2

    content {
      name = "Stage-${stage.value["name"]}"

      action {
        name             = "Action-${stage.value["name"]}"
        category         = stage.value["category"]
        owner            = stage.value["owner"]
        provider         = stage.value["provider"]
        version          = "1"
        run_order        = index(var.stages_phase2, stage.value) + 2
        input_artifacts  = [stage.value["input_artifacts"]]
        output_artifacts = [stage.value["output_artifacts"]]

        configuration = stage.value["provider"] == "CodeBuild" ? {
          ProjectName = "${var.project_name}-${stage.value["name"]}"
        } : {}
      }
    }
  }
}
