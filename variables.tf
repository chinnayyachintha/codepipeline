#-------------------------
# eks-codepipeline variables
#------------------------------
# ---------------------------------------
# Common Variables for AWS CodePipeline with Bitbucket
# ---------------------------------------
variable "aws_region" {
  description = "AWS region where the resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Unique name for this project"
  type        = string
}

variable "environment" {
  description = "Environment in which the script is run. Eg: dev, prod, etc"
  type        = string
}

# ---------------------------------------
# Codestar Connection with Bitbucket variables
# ---------------------------------------

variable "connection_name" {
  description = "Name of the CodeStar Connection"
  type        = string
  default     = "eks-bitbucket-connection"
}

variable "provider_type" {
  description = "Type of the provider for the CodeStar Connection"
  type        = string
  default     = "Bitbucket"
}

# ---------------------------------------
# IAM Role for CodePipeline Execution variables
# ---------------------------------------
variable "create_new_role" {
  description = "Whether to create a new IAM Role. Values are true or false. Defaulted to true always."
  type        = bool
  default     = true
}

variable "codepipeline_iam_role_name" {
  description = "Name of the IAM role to be used by the Codepipeline"
  type        = string
  default     = "pl-devops-dev-codepipeline-role"
}

#--------------------
# Codebuild variables
#--------------------
variable "role_arn" {
  description = "Codepipeline IAM role arn. "
  type        = string
  default     = ""
}

# variable "tags" {
#   description = "Tags to be applied to the codebuild project"
#   type        = map(any)
# }

variable "builder_compute_type" {
  description = "Relative path to the Apply and Destroy build spec file"
  type        = string
  default     = "BUILD_GENERAL1_SMALL"
}

variable "builder_image" {
  description = "Docker Image to be used by codebuild"
  type        = string
  default     = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
}

variable "builder_type" {
  description = "Type of codebuild run environment"
  type        = string
  default     = "LINUX_CONTAINER"
}

variable "builder_image_pull_credentials_type" {
  description = "Image pull credentials type used by codebuild project"
  type        = string
  default     = "CODEBUILD"
}

variable "build_project_source" {
  description = "aws/codebuild/standard:4.0"
  type        = string
  default     = "CODEPIPELINE"
}

variable "phase1_build_projects" {
  description = "List of build projects for phase 1"
  type        = list(string)
}

variable "phase2_build_projects" {
  description = "List of build projects for phase 2"
  type        = list(string)
}

variable "phase1_buildspec" {
  type = string
}

variable "phase2_buildspec" {
  type = string
}

#----------------------
# CodePipeline variables  
#----------------------
variable "source_repo_name" {
  description = "Bitbucket repository name in the format workspace/repo"
  type        = string
}

variable "source_repo_branch" {
  description = "Repository branch to track (e.g., main)"
  type        = string
}

variable "stages_phase1" {
  description = "List of Map containing information about the stages of the CodePipeline"
  type        = list(map(any))
}

variable "stages_phase2" {
  description = "List of Map containing information about the stages of the CodePipeline"
  type        = list(map(any))
}

variable "phase1_file_path" {
  type = list(string)
}

variable "phase2_file_path" {
  type = list(string)
}