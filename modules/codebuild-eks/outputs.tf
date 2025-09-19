output "phase1_codebuild_project_ids" {
  description = "IDs of the Phase 1 CodeBuild projects"
  value       = [for p in aws_codebuild_project.phase1_codebuild_project : p.id]
}

output "phase1_codebuild_project_names" {
  description = "Names of the Phase 1 CodeBuild projects"
  value       = [for p in aws_codebuild_project.phase1_codebuild_project : p.name]
}

output "phase1_codebuild_project_arns" {
  description = "ARNs of the Phase 1 CodeBuild projects"
  value       = [for p in aws_codebuild_project.phase1_codebuild_project : p.arn]
}

output "phase2_codebuild_project_ids" {
  description = "IDs of the Phase 2 CodeBuild projects"
  value       = [for p in aws_codebuild_project.phase2_codebuild_project : p.id]
}

output "phase2_codebuild_project_names" {
  description = "Names of the Phase 2 CodeBuild projects"
  value       = [for p in aws_codebuild_project.phase2_codebuild_project : p.name]
}

output "phase2_codebuild_project_arns" {
  description = "ARNs of the Phase 2 CodeBuild projects"
  value       = [for p in aws_codebuild_project.phase2_codebuild_project : p.arn]
}
