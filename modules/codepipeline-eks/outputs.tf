#---------------------------------
# Outputs for Phase-1 CodePipeline
#----------------------------------
output "phase1_pipeline_id" {
  description = "The ID of the Phase-1 CodePipeline"
  value       = aws_codepipeline.terraform_pipeline_phase1.id
}

output "phase1_pipeline_name" {
  description = "The name of the Phase-1 CodePipeline"
  value       = aws_codepipeline.terraform_pipeline_phase1.name
}

output "phase1_pipeline_arn" {
  description = "The ARN of the Phase-1 CodePipeline"
  value       = aws_codepipeline.terraform_pipeline_phase1.arn
}

#---------------------------------
# Outputs for Phase-2 CodePipeline
#----------------------------------
output "phase2_pipeline_id" {
  description = "The ID of the Phase-2 CodePipeline"
  value       = aws_codepipeline.terraform_pipeline_phase2.id
}

output "phase2_pipeline_name" {
  description = "The name of the Phase-2 CodePipeline"
  value       = aws_codepipeline.terraform_pipeline_phase2.name
}

output "phase2_pipeline_arn" {
  description = "The ARN of the Phase-2 CodePipeline"
  value       = aws_codepipeline.terraform_pipeline_phase2.arn
}
