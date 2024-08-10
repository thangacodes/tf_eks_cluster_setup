locals {
  common_name = "eks-terraform"
}

data "aws_availability_zones" "available" {}
output "available_zones" {
  value = data.aws_availability_zones.available.names
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = local.common_name
  cidr = var.vpc_cidr

  azs             = data.aws_availability_zones.available.names[*]
  private_subnets = var.private_subnet_cidr
  public_subnets  = var.public_subnet_cidr

  enable_nat_gateway = true

  tags = {
    "kubernetes.io/cluster/${local.common_name}" = "shared"
  }
}
