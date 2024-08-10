resource "aws_iam_role" "noderole" {
  name = "${local.common_name}-WorkerNGRole"

  assume_role_policy = <<POLICY
    {
       "Version": "2012-10-17",
       "Statement": [ 
         {
           "Effect": "Allow",
           "Principal": {
              "Service": "ec2.amazonaws.com"
           },
           "Action": "sts:AssumeRole"
        }
       ]
    }
POLICY
}

resource "aws_iam_role_policy_attachment" "node_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.noderole.name
}

resource "aws_iam_role_policy_attachment" "node_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.noderole.name
}

resource "aws_iam_role_policy_attachment" "node_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.noderole.name
}

## The ami_id can be dynamically retrieved using the Terraform datasource
data "aws_ami" "amazon-ami" {
  most_recent = true
  owners      = ["137112412989"]
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.20240719.0-x86_64-gp2"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
## Setting up the launch configuration template for the worker node group and updating it
resource "aws_launch_template" "lconfig" {
  name          = "eks-workernodes-cft"
  image_id      = data.aws_ami.amazon-ami.id
  instance_type = "t3.micro"
  key_name      = "mac"
  tags = {
    Name = "eks-worker-node-lct"
  }
}

## The eks worker node consists of launch_template and iam role policies
resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${local.common_name}-WNGP"
  node_role_arn   = aws_iam_role.noderole.arn
  subnet_ids      = module.vpc.private_subnets
  ami_type        = "AL2_x86_64"
  capacity_type   = "ON_DEMAND"
  disk_size       = 10
  instance_types  = ["t3.micro"]

  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 2
  }

  launch_template {
    id      = aws_launch_template.lconfig.id
    version = "$Latest" # Use "$Latest" to always use the latest version
  }

  depends_on = [
    aws_iam_role_policy_attachment.node_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node_AmazonEC2ContainerRegistryReadOnly,
    aws_eks_cluster.main
  ]
  tags = {
    Name = "${local.common_name}-WNGP"
  }
}
