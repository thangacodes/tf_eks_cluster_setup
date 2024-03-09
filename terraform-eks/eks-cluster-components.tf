
resource "aws_iam_role" "tf_eks_cluster_role" {
  name = "tf-eks-cluster-role"
  assume_role_policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : [
            "eks.amazonaws.com"
          ]
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
  tags = {
    Name         = "tf-eks-cluster-role"
    CreationDate = "09/03/2024"
    Owner        = "thangadurai.murugan@example.com"
    Project      = "GameApp-development"
    Description  = "This role is for EKS cluster ONLY"
  }
}

#### Policy_attachment
#### Attaching AmazonEKSClusterPolicy and AmazonEKSServicePolicy

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.tf_eks_cluster_role.name
}
resource "aws_iam_role_policy_attachment" "AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.tf_eks_cluster_role.name
}
resource "aws_iam_role_policy_attachment" "AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.tf_eks_cluster_role.name
}

### EKS Cluster Creation
resource "aws_eks_cluster" "aws-eks" {
  name     = "tf-eks-cluster"
  role_arn = aws_iam_role.tf_eks_cluster_role.arn
  vpc_config {
    subnet_ids         = ["subnet-070392f02684d57b0", "subnet-0493e4cd4178db942", "subnet-05c89932c5d61fc4a"]
    security_group_ids = [aws_security_group.eks-workernode-sg.id]
  }
  tags = {
    Name         = "tf-eks-cluster"
    CreationDate = "09/03/2024"
    Owner        = "thangadurai.murugan@example.com"
    Project      = "GameApp-development"
    Description  = "This role is for EKS cluster ONLY"
  }
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSServicePolicy,
    aws_iam_role_policy_attachment.AmazonEKSVPCResourceController
  ]

}

