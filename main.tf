# ---------------------------------------
# S3 bucket for storing pipeline artifacts
# ---------------------------------------
module "s3_artifacts_bucket" {
  source                = "./modules/s3-eks"
  project_name          = var.project_name
  kms_key_arn           = module.codepipeline_kms.arn
  codepipeline_role_arn = module.codepipeline_iam_role.role_arn
  # tags = {
  #   Project_Name = var.project_name
  #   Environment  = var.environment
  #   Account_ID   = local.account_id
  #   Region       = local.region
  # }
}

# ---------------------------------------
# Codestar Connection with Bitbucket
# ---------------------------------------
resource "aws_codestarconnections_connection" "bitbucket" {
  name          = var.connection_name
  provider_type = var.provider_type
}

# ---------------------------------------
# KMS Key for CodePipeline Encryption
# ---------------------------------------
module "codepipeline_kms" {
  source                = "./modules/kms-eks"
  codepipeline_role_arn = module.codepipeline_iam_role.role_arn

  # tags = {
  #   Project_Name = var.project_name
  #   Environment  = var.environment
  #   Account_ID   = local.account_id
  #   Region       = local.region
  # }
}

# ---------------------------------------
# IAM Role for CodePipeline Execution
# ---------------------------------------
module "codepipeline_iam_role" {
  source                     = "./modules/iam-role-eks"
  create_new_role            = var.create_new_role
  codepipeline_iam_role_name = var.create_new_role == true ? "${var.project_name}-codepipeline-role" : var.codepipeline_iam_role_name
  kms_key_arn                = module.codepipeline_kms.arn
  s3_bucket_arn              = module.s3_artifacts_bucket.arn
  environment                = var.environment

  # tags = {
  #   Project_Name = var.project_name
  #   Environment  = var.environment
  #   Account_ID   = local.account_id
  #   Region       = local.region
  # }
}

# ---------------------------------------
# CodeBuild for Terraform Validation
# ---------------------------------------
module "codebuild_terraform" {
  depends_on = [
    module.codepipeline_iam_role
  ]
  source = "./modules/codebuild-eks"

  project_name                        = var.project_name
  role_arn                            = module.codepipeline_iam_role.role_arn
  phase1_build_projects               = var.phase1_build_projects
  phase2_build_projects               = var.phase2_build_projects
  build_project_source                = var.build_project_source
  phase1_buildspec                    = var.phase1_buildspec
  phase2_buildspec                    = var.phase2_buildspec
  builder_compute_type                = var.builder_compute_type
  builder_image                       = var.builder_image
  builder_image_pull_credentials_type = var.builder_image_pull_credentials_type
  builder_type                        = var.builder_type
  kms_key_arn                         = module.codepipeline_kms.arn




  # tags = {
  #   Project_Name = var.project_name
  #   Environment  = var.environment
  #   Account_ID   = local.account_id
  #   Region       = local.region
  # }
}

# ---------------------------------------
# CodePipeline using Bitbucket source
# ---------------------------------------
module "codepipeline_terraform" {
  depends_on = [
    module.codebuild_terraform,
    module.s3_artifacts_bucket
  ]
  source = "./modules/codepipeline-eks"

  project_name             = var.project_name
  source_repo_name         = var.source_repo_name
  source_repo_branch       = var.source_repo_branch
  s3_bucket_name           = module.s3_artifacts_bucket.bucket
  codepipeline_role_arn    = module.codepipeline_iam_role.role_arn
  phase1_file_path         = var.phase1_file_path
  phase2_file_path         = var.phase2_file_path
  stages_phase1            = var.stages_phase1
  stages_phase2            = var.stages_phase2
  kms_key_arn              = module.codepipeline_kms.arn
  bitbucket_connection_arn = aws_codestarconnections_connection.bitbucket.arn


  # tags = {
  #   Project_Name = var.project_name
  #   Environment  = var.environment
  #   Account_ID   = local.account_id
  #   Region       = local.region
  # }
}


