#locals {
#  notebook_instance_name    = "notebook-instance-${var.team_name}"
#  notebook_instance_type    = "ml.t2.medium"
#  notebook_instance_subnet  = data.aws_subnets._private.ids[0]
#}

# Randomly select one subnet from the list
resource "random_shuffle" "subnet_shuffle" {
  input        = data.aws_subnets._private.ids
  result_count = 1
}

#resource "aws_sagemaker_notebook_instance" "notebook" {
#  name                   = local.notebook_instance_name
#  role_arn               = aws_iam_role.sagemaker_role.arn
#  instance_type          = local.notebook_instance_type
#  subnet_id              = local.notebook_instance_subnet
#  security_groups        = [aws_security_group.sagemaker_security_group.id]
#  direct_internet_access = "Disabled"
#  kms_key_id             = aws_kms_key.team_kms.arn
#  root_access            = "Disabled"
#  tags                   = merge(
#    local.common_tags,
#    {
#      "pam:technical:container" = "Sagemaker-Notebook",
#      "pam:technical:purpose"   = "Development",
#      "pam:technical:team"      = var.team_name
#    }
#  )
#}

#ml.t3.large | 2 CPU | 4 GiB RAM | $0.055 per hour
resource "aws_sagemaker_notebook_instance" "t3_medium" {
  name                   = "notebook-t3-medium"
  role_arn               = aws_iam_role.sagemaker_role.arn
  instance_type          = "ml.t3.medium"
  subnet_id              = random_shuffle.subnet_shuffle.result[0]
  security_groups        = [aws_security_group.sagemaker_security_group.id]
  direct_internet_access = "Disabled"
  #kms_key_id             = aws_kms_key.team_kms.arn
  root_access            = "Enabled"
  #volume_size            = 30
}
