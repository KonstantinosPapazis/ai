data "aws_iam_policy_document" "vpc_endpoints_all_resources" {
  statement {
    effect  = "Allow"
    actions = ["*"]
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "api_access" {
  statement {
    sid = "apigw"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${local.account_id}:root"]
    }
    actions   = ["execute-api:*"]
    resources = ["arn:aws:execute-api:${local.region}:${local.account_id}:*"]
  }
}

data "aws_iam_policy_document" "lambda_endpoint" {
  statement {
    sid    = "AllowAllActions"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = ["arn:aws:iam::${local.account_id}:root"]
    }
    actions = ["lambda:*"]
    resources = ["arn:aws:lambda:${local.region}:${local.account_id}:*"]
  }

  statement {
    sid    = "AllowListFunctions"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = ["arn:aws:iam::${local.account_id}:root"]
    }
    actions = ["lambda:ListFunctions"]
    # ListFunctions doesn't support filtering or conditions
    # See: https://docs.aws.amazon.com/lambda/latest/dg/lambda-api-permissions-ref.html
    resources = ["*"]
  }
}

## Api Gateway
resource "aws_vpc_endpoint" "api_gateway" {
  vpc_id              = aws_vpc.my_vpc.id
  service_name        = "com.amazonaws.${local.region}.execute-api"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.vpce_security_group.id]
  subnet_ids          = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
  private_dns_enabled = true
  policy              = data.aws_iam_policy_document.api_access.json
}

resource "aws_vpc_endpoint" "lambda" {
  vpc_id              = aws_vpc.my_vpc.id
  service_name        = "com.amazonaws.${local.region}.lambda"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.vpce_security_group.id]
  subnet_ids          = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
  private_dns_enabled = true
  policy              = data.aws_iam_policy_document.lambda_endpoint.json
}
