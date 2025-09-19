#----------------------------------
# eks-codepipeline variable values
#-----------------------------------
#-----------------
# Common Variables
#-----------------
aws_region   = "us-east-1"
project_name = "pl-devops-prod-eks"
environment  = "pl-devops-prod"

# tags = {
#   Environment = "pl-devops-prod"
#   Project     = "pl-devops-prod-eks"
# }

#---------------------------------------
# Codestar Connection (Bitbucket)
#---------------------------------------
connection_name = "eks-prod-bitbucket-connection"
provider_type   = "Bitbucket"

#---------------------------------------
# IAM Role Configuration
#---------------------------------------
create_new_role = true
# codepipeline_iam_role_name = "custom-pipeline-role"  # Only needed if create_new_role = false

#---------------------------------------
# Bitbucket Source Repository
#---------------------------------------
source_repo_name   = "resolutionlifeus/plfi-aws-infra-devops-setup"
source_repo_branch = "master"

#---------------------------------------
# CodeBuild Project Configuration
#---------------------------------------
phase1_buildspec = "./new-phase1-eks/prod"
phase2_buildspec = "./new-phase2-jenkins/prod"

phase1_build_projects = [
  "phase1_validate",
  "phase1_plan",
  "phase1_apply"
  # "destroy"
]

phase2_build_projects = [
  "phase2_validate",
  "phase2_plan",
  "phase2_apply"
  # "destroy"
]

build_project_source                = "CODEPIPELINE"
builder_compute_type                = "BUILD_GENERAL1_SMALL"
builder_image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
builder_image_pull_credentials_type = "CODEBUILD"
builder_type                        = "LINUX_CONTAINER"

#---------------------------------------
# CodePipeline Stages - Phase 1
#---------------------------------------
phase1_file_path = ["new-phase1-eks/prod/**/*"]
phase2_file_path = ["new-phase2-jenkins/prod/**/*"]

stages_phase1 = [
  {
    name             = "phase1_validate"
    category         = "Test"
    owner            = "AWS"
    provider         = "CodeBuild"
    input_artifacts  = "SourceOutput"
    output_artifacts = "ValidateOutput"
  },
  {
    name             = "phase1_plan"
    category         = "Test"
    owner            = "AWS"
    provider         = "CodeBuild"
    input_artifacts  = "ValidateOutput"
    output_artifacts = "PlanOutput"
  },
  {
    name             = "phase1_apply"
    category         = "Build"
    owner            = "AWS"
    provider         = "CodeBuild"
    input_artifacts  = "PlanOutput"
    output_artifacts = "ApplyOutput"
  }
]

#---------------------------------------
# CodePipeline Stages - Phase 2
#---------------------------------------
stages_phase2 = [
  {
    name             = "phase2_validate"
    category         = "Test"
    owner            = "AWS"
    provider         = "CodeBuild"
    input_artifacts  = "SourceOutput"
    output_artifacts = "ValidateOutput"
  },
  {
    name             = "phase2_plan"
    category         = "Test"
    owner            = "AWS"
    provider         = "CodeBuild"
    input_artifacts  = "ValidateOutput"
    output_artifacts = "PlanOutput"
  },
  {
    name             = "phase2_apply"
    category         = "Build"
    owner            = "AWS"
    provider         = "CodeBuild"
    input_artifacts  = "PlanOutput"
    output_artifacts = "ApplyOutput"
  }
]
