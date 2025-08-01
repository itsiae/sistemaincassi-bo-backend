#
# ------- Subnets -------
#

data "aws_subnet" "server_a" {
  filter {
    name   = "tag:Name"
    values = ["platform-enterprise-${var.vpc.stage}-server-a"]
  }
}
data "aws_subnet" "server_b" {
  filter {
    name   = "tag:Name"
    values = ["platform-enterprise-${var.vpc.stage}-server-b"]
  }
}
data "aws_subnet" "server_c" {
  filter {
    name   = "tag:Name"
    values = ["platform-enterprise-${var.vpc.stage}-server-c"]
  }
}

#
# ------- Security Groups -------
#
data "aws_security_group" "egress_everywhere" {
  tags = {
    "Name" = var.vpc.security_group
  }
}
