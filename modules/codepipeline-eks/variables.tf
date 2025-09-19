variable "project_name" {
  description = "Base name for the CodePipeline"
  type        = string
}

variable "codepipeline_role_arn" {
  description = "IAM Role ARN used by the CodePipeline"
  type        = string
}

variable "s3_bucket_name" {
  description = "S3 bucket to store CodePipeline artifacts"
  type        = string
}

variable "kms_key_arn" {
  description = "KMS key ARN to encrypt artifacts in S3"
  type        = string
}

variable "bitbucket_connection_arn" {
  description = "AWS CodeStar connection ARN to Bitbucket"
  type        = string
}

variable "source_repo_name" {
  description = "Bitbucket repository name in the format workspace/repo"
  type        = string
}

variable "source_repo_branch" {
  description = "Repository branch to track (e.g., main)"
  type        = string
}

# variable "tags" {
#   description = "Tags to apply to resources"
#   type        = map(string)
#   default     = {}
# }

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