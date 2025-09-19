resource "aws_codebuild_project" "phase1_codebuild_project" {
  count = length(var.phase1_build_projects)

  name           = "${var.project_name}-${var.phase1_build_projects[count.index]}"
  service_role   = var.role_arn
  encryption_key = var.kms_key_arn
  # tags           = var.tags

  artifacts {
    type = var.build_project_source
  }

  environment {
    compute_type                = var.builder_compute_type
    image                       = var.builder_image
    type                        = var.builder_type
    privileged_mode             = true
    image_pull_credentials_type = var.builder_image_pull_credentials_type
  }

  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }
  }

  source {
    type      = var.build_project_source
    buildspec = "${var.phase1_buildspec}/templates/buildspec_${var.phase1_build_projects[count.index]}.yml"
  }
}

resource "aws_codebuild_project" "phase2_codebuild_project" {
  count = length(var.phase2_build_projects)

  name           = "${var.project_name}-${var.phase2_build_projects[count.index]}"
  service_role   = var.role_arn
  encryption_key = var.kms_key_arn
  # tags           = var.tags

  artifacts {
    type = var.build_project_source
  }

  environment {
    compute_type                = var.builder_compute_type
    image                       = var.builder_image
    type                        = var.builder_type
    privileged_mode             = true
    image_pull_credentials_type = var.builder_image_pull_credentials_type
  }

  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }
  }

  source {
    type      = var.build_project_source
    buildspec = "${var.phase2_buildspec}/templates/buildspec_${var.phase2_build_projects[count.index]}.yml"
  }
}
