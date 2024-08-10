resource "aws_iam_role" "clusterrole" {
  name = "${local.common_name}-ClusterRole"

  assume_role_policy = <<POLICY
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Principal": {
            "Service": "eks.amazonaws.com"
          },
          "Action": "sts:AssumeRole"
        }
      ]
    }
  POLICY
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.clusterrole.name
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.clusterrole.name
}

resource "aws_eks_cluster" "main" {
  name     = "${local.common_name}-Cluster"
  role_arn = aws_iam_role.clusterrole.arn

  vpc_config {
    subnet_ids             = module.vpc.private_subnets
    endpoint_public_access = true
    public_access_cidrs    = ["0.0.0.0/0"]
  }
}
