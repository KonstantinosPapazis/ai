###########SG for Lambda########
resource "aws_security_group" "vpce_security_group" {
  name        = "vpce"
  description = "SG for vpce"
  vpc_id      = aws_vpc.my_vpc.id
  #tags        = local.common_tags
}

resource "aws_security_group_rule" "egress-vpce" {
  description       = "All egress from lambda"
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.vpce_security_group.id
}

resource "aws_security_group_rule" "vpce_https" {
  description       = "Ingress traffic for vpce HTTPS"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.vpce_security_group.id
  cidr_blocks       = [aws_vpc.my_vpc.cidr_block]
}
