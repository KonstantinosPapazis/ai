resource "aws_iam_role" "lambda_role" {
  name = "lambda_api_invoke_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
      },
    ],
  })
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "lambda_api_invoke_policy"
  description = "Policy to allow Lambda to invoke API Gateway"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "execute-api:Invoke",
        Effect = "Allow",
        Resource = "arn:aws:execute-api:eu-west-1:428858718180:${aws_api_gateway_rest_api.ai_frontdoor_api.id}/*/*/*"
      },
      {
        "Effect": "Allow",
        "Action": [
          "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface"
        ],
        "Resource": "*"
      },
      #{
      #  Effect = "Allow",
      #  Action = [
      #    "cloudwatch:ListMetrics",
      #    "cloudwatch:GetMetricData",
      #    "logs:GetQueryResults",
      #    "logs:StartQuery",
      #    "logs:FilterLogEvents",
      #    "ec2:DescribeSecurityGroups",
      #    "ec2:DescribeSubnets",
      #    "ec2:DescribeVpcs",
      #    "ec2:CreateNetworkInterface",
      #    "ec2:DescribeNetworkInterfaces",
      #    "ec2:DeleteNetworkInterface",
      #    "ec2:AssignPrivateIpAddresses",
      #    "ec2:UnassignPrivateIpAddresses",
      #    "kms:ListAliases",
      #    "iam:GetPolicy",
      #    "iam:GetPolicyVersion",
      #    "iam:GetRole",
      #    "iam:GetRolePolicy",
      #    "iam:ListAttachedRolePolicies",
      #    "iam:ListRolePolicies",
      #    "iam:ListRoles",
      #    "lambda:InvokeFunction",
      #    "lambda:GetFunctionConfiguration",
      #    "lambda:InvokeAsync",
      #    "lambda:GetFunction",
      #    "logs:DescribeLogGroups",
      #    "tag:GetResources",
      #    #"Sagemaker:createPresignedUrls",
      #  ],
      #  Resource = ["*"]
      #},
      #{
      #  Effect   = "Allow",
      #  Action   = "iam:PassRole",
      #  Resource = "*",
      #  Condition = {
      #    StringEquals = {
      #      "iam:PassedToService" : "lambda.amazonaws.com"
      #    }
      #  }
      #},
      #{
      #  Effect = "Allow",
      #  Action = [
      #    "logs:CreateLogGroup",
      #    "logs:CreateLogStream",
      #    "logs:PutLogEvents",
      #    "logs:DescribeLogStreams",
      #    "logs:GetLogEvents",
      #    "logs:FilterLogEvents",
      #  ],
      #  Resource = [
      #    "arn:aws:logs:*:*:log-group:/aws/lambda/*",
      #    "arn:aws:logs:*:*:log-group:/aws/lambda/*:log-stream:*",
      #  ]
      #},
    ],
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

resource "aws_lambda_function" "invoke_apigateway" {
  filename         = "lambda_function.zip"
  function_name    = "InvokeAPIGateway"
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.10"

  environment {
    variables = {
      API_GATEWAY_ID = aws_api_gateway_rest_api.ai_frontdoor_api.id
    }
  }

  vpc_config {
    subnet_ids         = data.aws_subnets._private.ids
    security_group_ids = [aws_security_group.lambda_security_group.id]
  }

  # Other configurations like memory_size, timeout, etc.
}

resource "aws_lambda_permission" "allow_api_invoke" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.invoke_apigateway.function_name
  principal     = "apigateway.amazonaws.com"
}
