data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_vpc" "vpc" {
  tags = {
    Environment = "test"
  }
}

data "aws_subnets" "_private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }

  tags = {
    Environment = "test"
    #Name       = "pam-ctsai-${var.environment_short}int-private-*" # filter out dms subnets
  }
}

data "aws_subnet" "private" {
  for_each = toset(data.aws_subnets._private.ids)
  id       = each.value
}


# data "aws_subnets" "_public" {
#   filter {
#     name   = "vpc-id"
#     values = [data.aws_vpc.vpc.id]
#   }

#   tags = {
#     Attributes = "public"
#     Name       = "pam-ctsai-${var.environment_short}int-public-*" # filter out dms subnets
#   }
# }

# data "aws_subnet" "public" {
#   for_each = toset(data.aws_subnets._public.ids)
#   id       = each.value
# }

##Retrieve the NAT GW ips so to use them in Sagemaker Policy for CodeCommit
# data "aws_nat_gateways" "all" {
#   filter {
#     name   = "state"
#     values = ["available"]
#   }
# }

# # Iterate over each NAT gateway ID and create a data source instance
# data "aws_nat_gateway" "details" {
#   for_each = toset(local.nat_gateway_ids)
#   id       = each.value
# }

data "aws_vpc_endpoint" "api_gateway" {
  vpc_id       = data.aws_vpc.vpc.id
  service_name = "com.amazonaws.eu-west-1.execute-api"
  state        = "available"
}
