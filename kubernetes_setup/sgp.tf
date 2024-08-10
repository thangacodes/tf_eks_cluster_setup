resource "aws_security_group" "node_group_sgp" {
  name        = "${local.common_name}-node-SGP"
  description = "Allow TLS inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allow nodes to communicate with each other"
    from_port   = 0
    to_port     = 65535
    protocol    = "-1"
  }
  ingress {
    from_port = 1025
    to_port   = 65535
    protocol  = "tcp"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name                                                 = "${local.common_name}-node-SGP"
    "kubernetes.io/cluster/${local.common_name}-cluster" = "owned"
  }
}
