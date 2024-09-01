###########SG for Sagemaker########
resource "aws_security_group" "sagemaker_security_group" {
  name        = "sagemaker-sg-test"
  description = "SG for SageMaker test"
  vpc_id      = data.aws_vpc.vpc.id

}

resource "aws_security_group_rule" "sagemaker_internal" {
  description       = "Ingress traffic for sagemaker components "
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  security_group_id = aws_security_group.sagemaker_security_group.id
  self              = true

}

resource "aws_security_group_rule" "egress-sagemaker" {
  description       = "All egress from sagemaker "
  type              = "egress"
  from_port         = 1025
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = [data.aws_vpc.vpc.cidr_block]
  security_group_id = aws_security_group.sagemaker_security_group.id
}


resource "aws_security_group_rule" "egress-sagemaker3" {
  description       = "All egress from sagemaker3 "
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sagemaker_security_group.id
}


resource "aws_security_group_rule" "sagemaker_internal_vpc" {
  description       = "Ingress traffic for sagemaker components from VPC for "
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  security_group_id = aws_security_group.sagemaker_security_group.id
  cidr_blocks       = [data.aws_vpc.vpc.cidr_block]
}