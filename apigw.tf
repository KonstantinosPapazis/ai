# API Gateway Resource
resource "aws_api_gateway_rest_api" "ai_frontdoor_api" {
  name = "ai_frontdoor"
  endpoint_configuration {
    types            = ["PRIVATE"]
    vpc_endpoint_ids = [data.aws_vpc_endpoint.api_gateway.id]
  }
  #tags = merge(local.common_tags, { "pam:technical:container" = "Apigateway" }, { "pam:technical:purpose" = "TBD" }, { "pam:technical:version" = "v1_0_0" })
}

#resource "aws_api_gateway_rest_api_policy" "ai_frontdoor_api_policy" {
#  rest_api_id = aws_api_gateway_rest_api.ai_frontdoor_api.id
#  policy = jsonencode({
#    Version = "2012-10-17",
#    Statement = [
#      #{
#      #  Effect    = "Allow",
#      #  Principal = "*",
#      #  Action    = "execute-api:Invoke",
#      #  Resource = [
#      #    "arn:aws:execute-api:${var.region}:${var.account_id}:${aws_api_gateway_rest_api.ai_frontdoor_api.id}/${var.environment}/POST/ai-frontdoor/llm-access-logs",
#      #    "arn:aws:execute-api:${var.region}:${var.account_id}:${aws_api_gateway_rest_api.ai_frontdoor_api.id}/${var.environment}/GET/ai-frontdoor/llm-cost-tracking",
#      #    "arn:aws:execute-api:${var.region}:${var.account_id}:${aws_api_gateway_rest_api.ai_frontdoor_api.id}/${var.environment}/GET/ai-frontdoor/llm-proof-of-pricing"
#      #  ],
#      #  Condition = {
#      #    StringEquals = {
#      #      "aws:PrincipalOrgID" = "o-w26re39qgn"
#      #      #"aws:PrincipalAccount" = var.account_id
#      #    }
#      #  }
#      #},
#      #{
#      #  Effect    = "Allow",
#      #  Principal = "*",
#      #  Action    = "execute-api:Invoke",
#      #  Resource = [
#      #    #"*",
#      #    "arn:aws:execute-api:${var.region}:${var.account_id}:${aws_api_gateway_rest_api.ai_frontdoor_api.id}/${var.environment}/GET/ping"
#      #    #"arn:aws:execute-api:${var.region}:${var.account_id}:${aws_api_gateway_rest_api.ai_frontdoor_api.id}/${var.environment}/POST/ai-frontdoor/llm-access-logs",
#      #    #"arn:aws:execute-api:${var.region}:${var.account_id}:${aws_api_gateway_rest_api.ai_frontdoor_api.id}/${var.environment}/GET/ai-frontdoor/llm-cost-tracking",
#      #    #"arn:aws:execute-api:${var.region}:${var.account_id}:${aws_api_gateway_rest_api.ai_frontdoor_api.id}/${var.environment}/GET/ai-frontdoor/llm-proof-of-pricing"
#      #  ],
#      #  "Condition": {
#      #    "StringEquals": {
#      #      "aws:SourceVpce": data.aws_vpc_endpoint.api_gateway.id
#      #    }
#      #  }
#      #  #Condition = {
#      #  #  StringEquals = {
#      #  #    "aws:PrincipalOrgID" = "o-w26re39qgn"
#      #  #    #"aws:PrincipalAccount" = var.account_id
#      #  #  }
#      #  #}
#      #},
#      {
#        Effect    = "Allow",
#        Principal = "*",
#        Action    = "*",
#        Resource = [
#          "*",
#          #"arn:aws:execute-api:${var.region}:${var.account_id}:${aws_api_gateway_rest_api.ai_frontdoor_api.id}/${var.environment}/GET/ping"
#          #"arn:aws:execute-api:${var.region}:${var.account_id}:${aws_api_gateway_rest_api.ai_frontdoor_api.id}/${var.environment}/POST/ai-frontdoor/llm-access-logs",
#          #"arn:aws:execute-api:${var.region}:${var.account_id}:${aws_api_gateway_rest_api.ai_frontdoor_api.id}/${var.environment}/GET/ai-frontdoor/llm-cost-tracking",
#          #"arn:aws:execute-api:${var.region}:${var.account_id}:${aws_api_gateway_rest_api.ai_frontdoor_api.id}/${var.environment}/GET/ai-frontdoor/llm-proof-of-pricing"
#        ],
#        #"Condition": {
#        #  "StringEquals": {
#        #    "aws:SourceVpce": data.aws_vpc_endpoint.api_gateway.id
#        #  }
#        #}
#        #Condition = {
#        #  StringEquals = {
#        #    "aws:PrincipalOrgID" = "o-w26re39qgn"
#        #    #"aws:PrincipalAccount" = var.account_id
#        #  }
#        #}
#      }
#    ]
#  })
#}

resource "aws_api_gateway_rest_api_policy" "ai_frontdoor_api_policy" {
  rest_api_id = aws_api_gateway_rest_api.ai_frontdoor_api.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*",
        Action    = "execute-api:Invoke",
        Resource = [
          "arn:aws:execute-api:eu-west-1:428858718180:${aws_api_gateway_rest_api.ai_frontdoor_api.id}/*/*"
        ],
        #Condition = {
        #  StringEquals = {
        #    "aws:SourceVpce": data.aws_vpc_endpoint.api_gateway.id
        #  }
        #}
      }
    ]
  })
}


# API Gateway Resource
resource "aws_api_gateway_resource" "ai_frontdoor_resource" {
  rest_api_id = aws_api_gateway_rest_api.ai_frontdoor_api.id
  parent_id   = aws_api_gateway_rest_api.ai_frontdoor_api.root_resource_id
  path_part   = "ai-frontdoor"
}

##Sub resources of ai-frontdoor
resource "aws_api_gateway_resource" "ai_frontdoor_llm_access_logs_resource" {
  rest_api_id = aws_api_gateway_rest_api.ai_frontdoor_api.id
  parent_id   = aws_api_gateway_resource.ai_frontdoor_resource.id
  path_part   = "llm-access-logs"
}

#resource "aws_api_gateway_resource" "ai_frontdoor_llm_cost_tracking_resource" {
#  rest_api_id = aws_api_gateway_rest_api.ai_frontdoor_api.id
#  parent_id   = aws_api_gateway_resource.ai_frontdoor_resource.id
#  path_part   = "llm-cost-tracking"
#}
#
#resource "aws_api_gateway_resource" "ai_frontdoor_llm_proof_of_pricing_resource" {
#  rest_api_id = aws_api_gateway_rest_api.ai_frontdoor_api.id
#  parent_id   = aws_api_gateway_resource.ai_frontdoor_resource.id
#  path_part   = "llm-proof-of-pricing"
#}


resource "aws_api_gateway_deployment" "ai_frontdoor_deployment" {
  depends_on = [
    #aws_api_gateway_integration.lambda_integration_llm_log_access,
    #aws_api_gateway_integration.lambda_integration_llm_cost_tracking,
    #aws_api_gateway_integration.lambda_integration_llm_proof_of_pricing,
    aws_api_gateway_integration.ping_integration
  ]

  rest_api_id = aws_api_gateway_rest_api.ai_frontdoor_api.id

  variables = {
    deployed_at = "${timestamp()}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

######AI frontdoor integration
#resource "aws_api_gateway_integration" "lambda_integration_llm_log_access" {
#  rest_api_id             = aws_api_gateway_rest_api.ai_frontdoor_api.id
#  resource_id             = aws_api_gateway_resource.ai_frontdoor_llm_access_logs_resource.id
#  http_method             = aws_api_gateway_method.ai_front_door_llm_log_access.http_method
#  integration_http_method = "POST"
#  type                    = "AWS_PROXY"
#  uri                     = aws_lambda_function.ai_frontdoor_llm_log_access.invoke_arn
#
#  depends_on = [
#    aws_api_gateway_method.ai_front_door_llm_log_access
#  ]
#}
#
#resource "aws_api_gateway_method" "ai_front_door_llm_log_access" {
#  rest_api_id      = aws_api_gateway_rest_api.ai_frontdoor_api.id
#  resource_id      = aws_api_gateway_resource.ai_frontdoor_llm_access_logs_resource.id
#  http_method      = "POST"
#  authorization    = "NONE"
#  api_key_required = true
#}
#
#resource "aws_api_gateway_integration" "lambda_integration_llm_cost_tracking" {
#  rest_api_id             = aws_api_gateway_rest_api.ai_frontdoor_api.id
#  resource_id             = aws_api_gateway_resource.ai_frontdoor_llm_cost_tracking_resource.id
#  http_method             = aws_api_gateway_method.ai_front_door_llm_cost_tracking.http_method
#  integration_http_method = "POST"
#  type                    = "AWS_PROXY"
#  uri                     = aws_lambda_function.ai_frontdoor_llm_cost_tracking.invoke_arn
#
#  lifecycle {
#    create_before_destroy = true
#  }
#
#  depends_on = [
#    aws_api_gateway_method.ai_front_door_llm_cost_tracking
#  ]
#}
#
#resource "aws_api_gateway_method" "ai_front_door_llm_cost_tracking" {
#  rest_api_id      = aws_api_gateway_rest_api.ai_frontdoor_api.id
#  resource_id      = aws_api_gateway_resource.ai_frontdoor_llm_cost_tracking_resource.id
#  http_method      = "GET"
#  authorization    = "NONE"
#  api_key_required = false
#}
#
#resource "aws_api_gateway_integration" "lambda_integration_llm_proof_of_pricing" {
#  rest_api_id             = aws_api_gateway_rest_api.ai_frontdoor_api.id
#  resource_id             = aws_api_gateway_resource.ai_frontdoor_llm_proof_of_pricing_resource.id
#  http_method             = aws_api_gateway_method.ai_front_door_llm_proof_of_pricing.http_method
#  integration_http_method = "POST"
#  type                    = "AWS_PROXY"
#  uri                     = aws_lambda_function.ai_frontdoor_llm_proof_of_pricing.invoke_arn
#
#  lifecycle {
#    create_before_destroy = true
#  }
#
#  depends_on = [
#    aws_api_gateway_method.ai_front_door_llm_proof_of_pricing
#  ]
#}
#
#resource "aws_api_gateway_method" "ai_front_door_llm_proof_of_pricing" {
#  rest_api_id      = aws_api_gateway_rest_api.ai_frontdoor_api.id
#  resource_id      = aws_api_gateway_resource.ai_frontdoor_llm_proof_of_pricing_resource.id
#  http_method      = "POST" #"GET"
#  authorization    = "NONE"
#  api_key_required = false
#}
#
#resource "aws_lambda_permission" "api_gateway_llm_cost_tracking_permission" {
#  statement_id  = "AllowAPIGatewayInvoke"
#  action        = "lambda:InvokeFunction"
#  function_name = aws_lambda_function.ai_frontdoor_llm_cost_tracking.function_name
#  principal     = "apigateway.amazonaws.com"
#  source_arn    = "arn:aws:execute-api:${var.region}:${var.account_id}:${aws_api_gateway_rest_api.ai_frontdoor_api.id}/*/${aws_api_gateway_method.ai_front_door_llm_cost_tracking.http_method}${aws_api_gateway_resource.ai_frontdoor_llm_cost_tracking_resource.path}"
#}
#
#resource "aws_lambda_permission" "api_gateway_lambda_llm_log_access_permission" {
#  statement_id  = "AllowAPIGatewayInvoke"
#  action        = "lambda:InvokeFunction"
#  function_name = aws_lambda_function.ai_frontdoor_llm_log_access.function_name
#  principal     = "apigateway.amazonaws.com"
#  source_arn    = "${aws_api_gateway_rest_api.ai_frontdoor_api.execution_arn}/*/POST/${aws_api_gateway_resource.ai_frontdoor_resource.path_part}/${aws_api_gateway_resource.ai_frontdoor_llm_access_logs_resource.path_part}"
#}
#
#resource "aws_lambda_permission" "api_gateway_lambda_llm_proof_of_pricing_permission" {
#  statement_id  = "AllowAPIGatewayInvoke"
#  action        = "lambda:InvokeFunction"
#  function_name = aws_lambda_function.ai_frontdoor_llm_proof_of_pricing.function_name
#  principal     = "apigateway.amazonaws.com"
#  source_arn    = "${aws_api_gateway_rest_api.ai_frontdoor_api.execution_arn}/*/POST/${aws_api_gateway_resource.ai_frontdoor_resource.path_part}/${aws_api_gateway_resource.ai_frontdoor_llm_proof_of_pricing_resource.path_part}"
#}
#
resource "aws_api_gateway_stage" "ai_frontdoor_stage" {
  stage_name    = "test"
  rest_api_id   = aws_api_gateway_rest_api.ai_frontdoor_api.id
  deployment_id = aws_api_gateway_deployment.ai_frontdoor_deployment.id

  #access_log_settings {
  #  destination_arn = aws_cloudwatch_log_group.pam_ai_frontdoor_log_group.arn
  #  format          = "{\"requestId\":\"$context.requestId\", \"ip\":\"$context.identity.sourceIp\", \"requestTime\":\"$context.requestTime\", \"httpMethod\":\"$context.httpMethod\", \"routeKey\":\"$context.routeKey\", \"status\":\"$context.status\", \"protocol\":\"$context.protocol\", \"responseLength\":\"$context.responseLength\"}"
  #}

  lifecycle {
    create_before_destroy = true
  }
}

# API Gateway Resource - /ping
resource "aws_api_gateway_resource" "ai_frontdoor_ping_resource" {
  rest_api_id = aws_api_gateway_rest_api.ai_frontdoor_api.id
  parent_id   = aws_api_gateway_rest_api.ai_frontdoor_api.root_resource_id
  path_part   = "ping"
}

# Method for /ping resource
resource "aws_api_gateway_method" "ai_front_door_ping_method" {
  rest_api_id      = aws_api_gateway_rest_api.ai_frontdoor_api.id
  resource_id      = aws_api_gateway_resource.ai_frontdoor_ping_resource.id
  http_method      = "GET"
  authorization    = "NONE" #"AWS_IAM"
  api_key_required = false
}

# Integration for /ping resource using MOCK type
#resource "aws_api_gateway_integration" "ping_integration" {
#  rest_api_id             = aws_api_gateway_rest_api.ai_frontdoor_api.id
#  resource_id             = aws_api_gateway_resource.ai_frontdoor_ping_resource.id
#  http_method             = aws_api_gateway_method.ai_front_door_ping_method.http_method
#  integration_http_method = "GET"
#  type                    = "MOCK"
#
#  request_templates = {
#    "application/json" = "{\"statusCode\": 200}"
#  }
#}

resource "aws_api_gateway_integration" "ping_integration" {
  rest_api_id             = aws_api_gateway_rest_api.ai_frontdoor_api.id
  resource_id             = aws_api_gateway_resource.ai_frontdoor_ping_resource.id
  http_method             = aws_api_gateway_method.ai_front_door_ping_method.http_method
  integration_http_method = "ANY"  # This should ideally be "ANY" for a MOCK type
  type                    = "MOCK"
  passthrough_behavior    = "NEVER"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }

  lifecycle {
    ignore_changes = [
      cache_namespace,
      id,
      integration_http_method,
    ]
  }
}

# Method response for /ping resource
resource "aws_api_gateway_method_response" "ping_method_response" {
  rest_api_id = aws_api_gateway_rest_api.ai_frontdoor_api.id
  resource_id = aws_api_gateway_resource.ai_frontdoor_ping_resource.id
  http_method = aws_api_gateway_method.ai_front_door_ping_method.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }



  response_models = {
    "application/json" = "Empty"
  }
}

# Integration response for /ping resource
resource "aws_api_gateway_integration_response" "ping_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.ai_frontdoor_api.id
  resource_id = aws_api_gateway_resource.ai_frontdoor_ping_resource.id
  http_method = aws_api_gateway_method.ai_front_door_ping_method.http_method
  status_code = aws_api_gateway_method_response.ping_method_response.status_code

  response_templates = {
    "application/json" = "{\"message\": \"Ping successful\"}"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

  depends_on = [
    aws_api_gateway_integration.ping_integration
  ]
}


