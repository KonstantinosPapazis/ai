###########SG for Lambda########
resource "aws_security_group" "lambda_security_group" {
  name        = "lambda_sg"
  description = "SG for lambda"
  vpc_id      = data.aws_vpc.vpc.id
  #tags        = local.common_tags
}

resource "aws_security_group_rule" "lambda_internal" {
  description       = "Ingress traffic for lambda components"
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  security_group_id = aws_security_group.lambda_security_group.id
  self              = true
}

resource "aws_security_group_rule" "egress-lambda" {
  description       = "All egress from lambda"
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lambda_security_group.id
}

resource "aws_security_group_rule" "lambda_internal_vpc" {
  description       = "Ingress traffic for lambda components from VPC"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.lambda_security_group.id
  cidr_blocks       = [data.aws_vpc.vpc.cidr_block]
}
