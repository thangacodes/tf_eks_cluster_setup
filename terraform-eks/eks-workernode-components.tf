resource "aws_iam_role" "tf_eks_workernode_role" {
  name = "tf-eks-workernode-role"
  assume_role_policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : [
            "ec2.amazonaws.com"
          ]
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
  tags = {
    Name         = "tf-eks-workernode-role"
    CreationDate = "09/03/2024"
    Owner        = "thangadurai.murugan@example.com"
    Project      = "GameApp-deployment"
    Description  = "This role is for EKS worker-node ONLY"
  }
}

### Policy attachement
resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.tf_eks_workernode_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.tf_eks_workernode_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.tf_eks_workernode_role.name
}

### EKS Worker Node group creation
resource "aws_eks_node_group" "node-group" {
  cluster_name    = aws_eks_cluster.aws-eks.name
  node_group_name = "tf_worker_node_group"
  node_role_arn   = aws_iam_role.tf_eks_workernode_role.arn
  subnet_ids      = ["subnet-e9190a81", "subnet-03e0a14f"]
  disk_size       = 20
  instance_types  = ["t3.small"]
  remote_access {
    ec2_ssh_key               = "tfuser"
    source_security_group_ids = [aws_security_group.eks-workernode-sg.id]
  }
  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 1
  }
  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
  tags = {
    Name         = "tf-eks-workernodes"
    CreationDate = "09/03/2024"
    Owner        = "thangadurai.murugan@example.com"
    Project      = "GameApp-development"
    Description  = "This role is for EKS cluster ONLY"
  }
}
