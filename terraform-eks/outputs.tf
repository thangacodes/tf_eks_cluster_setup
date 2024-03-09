## EKS cluster endpoint and CA details

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.aws-eks.endpoint
}

output "eks_cluster_certificate_authority" {
  value = aws_eks_cluster.aws-eks.certificate_authority
}

### Bastion host IP details
output "bastion-pubip" {
  value = aws_instance.jump-server.public_ip
}
