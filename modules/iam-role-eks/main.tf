resource "aws_iam_role" "codepipeline_role" {
  count = var.create_new_role ? 1 : 0
  name  = var.codepipeline_iam_role_name
  path  = "/"
  # tags  = var.tags

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "codepipeline.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      },
      {
        Effect = "Allow",
        Principal = {
          Service = "codebuild.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "codepipeline_policy" {
  count       = var.create_new_role ? 1 : 0
  name        = "${var.environment}-eks-codepipeline-policy"
  description = "IAM policy for CodePipeline and CodeBuild to deploy infrastructure"
  # tags        = var.tags

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      # (all your custom permissions already present)
      {
        Sid : "S3ArtifactsAndBackend",
        Effect : "Allow",
        Action : [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:DeleteObject",
          "s3:ListBucket"
        ],
        Resource : [
          "${var.s3_bucket_arn}",
          "${var.s3_bucket_arn}/*",
          "*"
        ]
      },
      {
        Sid : "TerraformDynamoDBLocking",
        Effect : "Allow",
        Action : [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem",
          "dynamodb:Scan",
          "dynamodb:DescribeTable"
        ],
        Resource : "*"
      },
      {
        Sid : "EKSAccess",
        Effect : "Allow",
        Action : [
          "eks:DescribeCluster",
          "eks:ListClusters",
          "eks:ListNodegroups",
          "eks:DescribeNodegroup"
        ],
        Resource : "*"
      },
      {
        Sid : "EKSNodeGroupAccess",
        Effect : "Allow",
        Action : [
          "autoscaling:*",
          "ec2:Describe*",
          "eks:UpdateNodegroupConfig"
        ],
        Resource : "*"
      },
      {
        Sid : "VPCResourcesAccess",
        Effect : "Allow",
        Action : [
          "ec2:Describe*",
          "ec2:CreateSecurityGroup",
          "ec2:DeleteSecurityGroup",
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:AuthorizeSecurityGroupEgress",
          "ec2:RevokeSecurityGroupIngress",
          "ec2:RevokeSecurityGroupEgress"
        ],
        Resource : "*"
      },
      {
        Sid : "IAMAccess",
        Effect : "Allow",
        Action : [
          "iam:GetRole",
          "iam:PassRole",
          "iam:CreateRole",
          "iam:DeleteRole",
          "iam:PutRolePolicy",
          "iam:DeleteRolePolicy",
          "iam:AttachRolePolicy",
          "iam:DetachRolePolicy",
          "iam:TagRole"
        ],
        Resource : "*"
      },
      {
        Sid : "SecretsManagerAccess",
        Effect : "Allow",
        Action : [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret",
          "secretsmanager:ListSecrets"
        ],
        Resource : "*"
      },
      {
        Sid : "EFSAccess",
        Effect : "Allow",
        Action : [
          "elasticfilesystem:*"
        ],
        Resource : "*"
      },
      {
        Sid : "KMSAccess",
        Effect : "Allow",
        Action : [
          "kms:DescribeKey",
          "kms:GenerateDataKey*",
          "kms:Encrypt",
          "kms:ReEncrypt*",
          "kms:Decrypt"
        ],
        Resource : "${var.kms_key_arn}"
      },
      {
        Sid : "CodeServicesAccess",
        Effect : "Allow",
        Action : [
          "codebuild:StartBuild",
          "codebuild:BatchGetBuilds",
          "codebuild:BatchGetProjects",
          "codebuild:CreateReportGroup",
          "codebuild:CreateReport",
          "codebuild:UpdateReport",
          "codebuild:BatchPutTestCases",
          "codecommit:GetBranch",
          "codecommit:GetCommit",
          "codecommit:GitPull",
          "codecommit:ListRepositories",
          "codestar-connections:UseConnection"
        ],
        Resource : "*"
      },
      {
        Sid : "CloudWatchLogsAccess",
        Effect : "Allow",
        Action : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource : "*"
      }
    ]
  })
}

# Attach custom policy
resource "aws_iam_role_policy_attachment" "codepipeline_role_attach" {
  count      = var.create_new_role ? 1 : 0
  role       = aws_iam_role.codepipeline_role[0].name
  policy_arn = aws_iam_policy.codepipeline_policy[0].arn
}

# ✅ Attach AWS-managed AdministratorAccess policy
resource "aws_iam_role_policy_attachment" "codepipeline_admin_access" {
  count      = var.create_new_role ? 1 : 0
  role       = aws_iam_role.codepipeline_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
