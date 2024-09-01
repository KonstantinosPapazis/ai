resource "aws_iam_role" "sagemaker_role" {
  name                 = "SageMaker-test-Role"
  #permissions_boundary = data.aws_iam_policy.permission_boundary.arn

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "sagemaker.amazonaws.com"
        },
        #"Condition" : {
        #  "ArnLike" : {
        #    "aws:SourceArn" : "arn:aws:sagemaker:eu-west-1:428858718180:*"
        #    #https://.signin.aws.amazon.com/console
        #    #"aws:SourceArn" : "arn:aws:sagemaker:${var.replication_region}:${var.account_id}:*"
        #  }
        #}
      },
    ],
  })
}

#resource "aws_iam_policy" "sagemaker_codecommit_policy" {
#  name        = "PictetUM-Sagemaker-${var.team_name}-CodeCommit-Policy"
#  description = "SageMaker Studio policy for ${var.team_name} CodeCommit."
#
#  policy = jsonencode({
#    Version = "2012-10-17",
#    Statement = [
#      {
#        Sid    = "AllowCodeCommitActions",
#        Effect = "Allow",
#        Action = [
#          "codecommit:GitPull",
#          "codecommit:GitPush",
#          "codecommit:CreateBranch",
#          "codecommit:DeleteBranch",
#          "codecommit:GetBranch",
#          "codecommit:UpdateDefaultBranch",
#          "codecommit:GetRepository",
#          "codecommit:GetBlob",
#          "codecommit:GetCommit",
#          "codecommit:GetCommitHistory",
#          "codecommit:GetDifferences",
#          "codecommit:GetObjectIdentifier",
#          "codecommit:GetReferences",
#          "codecommit:GetTree",
#          "codecommit:BatchGetPullRequests",
#          "codecommit:CreatePullRequest*",
#          "codecommit:GetCommentsForPullRequest",
#          "codecommit:GetCommentsForComparedCommit",
#          "codecommit:GetCommitsFromMergeBase",
#          "codecommit:GetMerge*",
#          "codecommit:GetPull*",
#          "codecommit:DescribePullRequest*",
#          "codecommit:MergePullRequestByFastForward",
#          "codecommit:PostCommentForPullRequest",
#          "codecommit:UpdatePullRequestDescription",
#          "codecommit:UpdatePullRequestStatus",
#          "codecommit:UpdatePullRequestTitle",
#          "codecommit:Update*",
#          "codecommit:DescribePullRequestEvents",
#          "codecommit:Evaluate*",
#          "codecommit:UpdateComment",
#          "codecommit:DeleteComment*",
#          "codecommit:Post*",
#          "codecommit:List*",
#          "codecommit:Merge*",
#          "codecommit:PutComment*"
#        ],
#        Resource = [
#          "arn:aws:codecommit:*:*:*${var.team_name}*",
#        ],
#      },
#    ],
#  })
#}

#esource "aws_iam_role_policy_attachment" "sagemaker_policy_codecommit" {
# role       = aws_iam_role.sagemaker_role.name
# policy_arn = aws_iam_policy.sagemaker_codecommit_policy.arn
#

#resource "aws_iam_policy" "sagemaker_ecr_policy" {
#  name        = "PictetUM-Sagemaker-${var.team_name}-ECR-Policy"
#  description = "SageMaker Studio policy for ${var.team_name} ECR."
#
#  policy = jsonencode({
#    Version = "2012-10-17",
#    Statement = [
#      {
#        Sid    = "AllowECRActions",
#        Effect = "Allow",
#        Action = [
#          "ecr:SetRepositoryPolicy",
#          "ecr:CompleteLayerUpload",
#          "ecr:BatchDeleteImage",
#          "ecr:UploadLayerPart",
#          "ecr:DeleteRepositoryPolicy",
#          "ecr:InitiateLayerUpload",
#          "ecr:DeleteRepository",
#          "ecr:PutImage"
#        ],
#        Resource = [
#          "arn:aws:ecr:*:*:repository/*${var.team_name}*"
#        ]
#      },
#    ],
#  })
#}

#resource "aws_iam_role_policy_attachment" "sagemaker_policy_ecr" {
#  role       = aws_iam_role.sagemaker_role.name
#  policy_arn = aws_iam_policy.sagemaker_ecr_policy.arn
#}

resource "aws_iam_policy" "sagemaker_s3_policy" {
  name        = "PictetUM-Sagemaker-S3-Policy"
  description = "SageMaker Studio policy for S3."

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AllowS3ObjectActions",
        Effect = "Allow",
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:AbortMultipartUpload"
        ],
        Resource = [
          "arn:aws:s3:::*",
        ]
      },
      {
        Sid    = "AllowS3BucketActions",
        Effect = "Allow",
        Action = [
          "s3:CreateBucket",
          "s3:GetBucketLocation",
          "s3:ListBucket",
          #"s3:ListAllMyBuckets",
          "s3:GetBucketCors",
          "s3:PutBucketCors"
        ],
        Resource = [
          #"*"
          "arn:aws:s3:::*",
        ]
      },
      {
        Sid    = "AllowS3ListAllBucketsActions",
        Effect = "Allow",
        Action = [
          #"s3:CreateBucket",
          #"s3:GetBucketLocation",
          #"s3:ListBucket",
          "s3:ListAllMyBuckets",
          #"s3:GetBucketCors",
          #"s3:PutBucketCors"
        ],
        Resource = [
          "*"
          #"arn:aws:s3:::*${var.team_name}*",
        ]
      },
      {
        Sid    = "AllowS3BucketACL",
        Effect = "Allow",
        Action = [
          "s3:GetBucketAcl",
          "s3:PutObjectAcl"
        ],
        Resource = [
          "arn:aws:s3:::*",
        ]
      },
    ],
  })
}

resource "aws_iam_role_policy_attachment" "sagemaker_policy_s3" {
  role       = aws_iam_role.sagemaker_role.name
  policy_arn = aws_iam_policy.sagemaker_s3_policy.arn
}

resource "aws_iam_policy" "custom_sagemaker_policy" {
  name        = "CustomSagemakerPolicy"
  description = "SageMaker Studio custom policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AllowStudioActions",
        Effect = "Allow",
        Action = [
          "sagemaker:*",
          "sagemaker:Search",
          "sagemaker:ListNotebookInstances",
          "sagemaker:ListEndpoints",
          "sagemaker:InvokeEndpoint",
        ],
        Resource = "*"
      },
      {
        "Effect": "Allow",
        "Action": "sts:AssumeRole",
        "Resource": "arn:aws:iam::428858718180:role/SageMaker-test-Role"
      },
      #{
      #  Sid    = "AllowAPIGWInvoke",
      #  Effect = "Allow",
      #  Action = "execute-api:Invoke",
      #  Resource = "arn:aws:execute-api:eu-west-1:428858718180:ssmpha74bc/*/*/ping"
      #  "Condition": {
      #    "StringEquals": {
      #      "aws:SourceVpce": "vpce-0f79134bd6bdef9cd-e0z5bmpr"
      #    }
      #  }
      #},
      {
        Sid    = "AllowAPIGWInvoke",
        Effect = "Allow",
        Action = "execute-api:*",
        Resource = "*"
      },
      {
        Sid    = "AllowLambdaInvokeFunction",
        Effect = "Allow",
        Action = "lambda:InvokeFunction",
        Resource = [
          "arn:aws:lambda:*:*:function:*SageMaker*",
          "arn:aws:lambda:*:*:function:*sagemaker*",
          "arn:aws:lambda:*:*:function:*Sagemaker*",
          "arn:aws:lambda:*:*:function:*LabelingFunction*"
        ]
      },
      {
        Sid      = "AllowPassRoleToSageMaker",
        Effect   = "Allow",
        Action   = "iam:PassRole",
        Resource = "arn:aws:iam::*:role/*",
        Condition = {
          StringEquals = {
            "iam:PassedToService" = "sagemaker.amazonaws.com"
          }
        }
      },
      {
        Sid    = "AllowAWSServiceActions",
        Effect = "Allow",
        Action = [
          "application-autoscaling:DeleteScalingPolicy",
          "application-autoscaling:DeleteScheduledAction",
          "application-autoscaling:DeregisterScalableTarget",
          "application-autoscaling:DescribeScalableTargets",
          "application-autoscaling:DescribeScalingActivities",
          "application-autoscaling:DescribeScalingPolicies",
          "application-autoscaling:DescribeScheduledActions",
          "application-autoscaling:PutScalingPolicy",
          "application-autoscaling:PutScheduledAction",
          "application-autoscaling:RegisterScalableTarget",
          "cloudwatch:DescribeAlarms",
          "cloudwatch:GetMetricData",
          "cloudwatch:GetMetricStatistics",
          "cloudwatch:ListMetrics",
          "cloudwatch:PutMetricAlarm",
          "cloudwatch:PutMetricData",
          "codecommit:List*",
          #"cognito-idp:DescribeUserPool",
          #"cognito-idp:DescribeUserPoolClient",
          #"cognito-idp:List*",
          #"cognito-idp:UpdateUserPool",
          #"cognito-idp:UpdateUserPoolClient",
          "ec2:CreateNetworkInterface",
          "ec2:CreateNetworkInterfacePermission",
          "ec2:DeleteNetworkInterface",
          "ec2:DeleteNetworkInterfacePermission",
          "ec2:DescribeDhcpOptions",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DescribeRouteTables",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSubnets",
          "ec2:DescribeVpcEndpoints",
          "ec2:DescribeVpcs",
          "ecr:BatchCheckLayerAvailability",
          "ecr:Describe*",
          "elastic-inference:Connect",
          "elasticfilesystem:DescribeFileSystems",
          "elasticfilesystem:DescribeMountTargets",
          "lambda:ListFunctions",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:Describe*",
          "logs:GetLogEvents",
          "logs:PutLogEvents",
          "sns:ListTopics",
          "tag:GetResources",
          #"execute-api:Invoke", #TEST
        ],
        Resource = "*"
      },
      {
        Sid    = "AllowAPIGWActions",
        Effect = "Allow",
        Action = [
          "execute-api:Invoke",
        ],
        Resource = "arn:aws:execute-api:*"
      },
      {
        Sid      = "AllowSTSGetCallerIdentity",
        Effect   = "Allow",
        Action   = "sts:GetCallerIdentity",
        Resource = "*"
      }
    ],
  })
}


resource "aws_iam_role_policy_attachment" "custom_sagemaker_policy" {
  role       = aws_iam_role.sagemaker_role.name
  policy_arn = aws_iam_policy.custom_sagemaker_policy.arn
}

#resource "aws_iam_policy" "sagemaker_instance_types_policy" {
#  name        = "PictetUM-${var.team_name}-SagemakerInstanceTypePolicy"
#  description = "SageMaker ${var.team_name} Studio policy for EC2 Instance types."
#
#  policy = jsonencode({
#    Version : "2012-10-17",
#    Statement : [
#      {
#        Sid : "AllowCreateAndUpdateApp",
#        Effect : "Allow",
#        Action : [
#          "sagemaker:CreateApp"
#        ],
#        Resource : "*",
#        Condition : {
#          "StringEquals" : {
#            "sagemaker:InstanceTypes" : [
#              "ml.t3.medium",
#              "ml.t3.large",
#              "ml.m5.large",
#              "default",
#              "system"
#            ]
#          }
#        }
#      },
#      {
#        Sid : "ExplicitDenyOtherInstanceTypes",
#        Effect : "Deny",
#        Action : [
#          "sagemaker:CreateApp"
#        ],
#        Resource : "*",
#        Condition : {
#          "ForAllValues:StringNotLike" : {
#            "sagemaker:InstanceTypes" : [
#              "ml.t3.medium",
#              "ml.t3.large",
#              "ml.m5.large",
#              "default",
#              "system"
#            ]
#          }
#        }
#      }
#    ]
#  })
#}
#
#resource "aws_iam_role_policy_attachment" "sagemaker_instance_types_policy" {
#  role       = aws_iam_role.sagemaker_role.name
#  policy_arn = aws_iam_policy.sagemaker_instance_types_policy.arn
#}

###KMS
#resource "aws_iam_policy" "sagemaker_kms_access" {
#  name        = "PictetUM-SageMaker-${var.team_name}-KMSAccess"
#  description = "Allow SageMaker to access KMS keys for ${var.team_name}"
#
#  policy = jsonencode({
#    Version : "2012-10-17",
#    Statement : [
#      {
#        Effect : "Allow",
#        Action : [
#          "kms:Encrypt",
#          "kms:Decrypt",
#          "kms:ReEncrypt*",
#          "kms:GenerateDataKey*",
#          "kms:DescribeKey",
#          "kms:CreateGrant"
#        ],
#        Resource : [
#          aws_kms_key.team_kms.arn,
#        ]
#      },
#      {
#        "Sid" : "AllowUsePamaiKeyEncryptedGuardrail",
#        "Effect" : "Allow",
#        "Action" : "kms:Decrypt",
#        "Resource" : var.pamai_kms_key_arn
#      }
#    ]
#  })
#}
#
#resource "aws_iam_role_policy_attachment" "sagemaker_policy_kms" {
#  role       = aws_iam_role.sagemaker_role.name
#  policy_arn = aws_iam_policy.sagemaker_kms_access.arn
#}

resource "aws_iam_policy" "allow_assume_self" {
  name        = "AllowAssumeSelf"
  description = "Allows the role to assume itself"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "sts:AssumeRole",
        Resource = "arn:aws:iam::428858718180:role/SageMaker-test-Role"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "allow_assume_self" {
  role       = aws_iam_role.sagemaker_role.name
  policy_arn = aws_iam_policy.allow_assume_self.arn
}

