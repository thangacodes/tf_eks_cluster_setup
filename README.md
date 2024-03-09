## Amazon Elastic Kubernetes Service Creation Using Terraform IaC:

This project is tested and deployed in sandbox using Jenkins declarative method of CICD

## After installing kubectl on the Bastion or Jump server where you will connect your EKS cluster, follow these steps:

## The default Kubeconfig path is,

## /home/ec2-user/.kube/config  //In the case of an Amazon Linux machine

## For EKS clusters, update the kubeconfig file. 
   aws eks update-kubeconfig --region ap-south-1 --name tf-eks-cluster

## In addition, if you have an IAM EKS role with assum policy enabled, you can run the following command,
   aws eks update-kubeconfig --region ap-south-1 --name tf-eks-cluster --role-arn arn:aws:iam::XXYYYXYXYXYXYXY:role/ec2-admin-role


## In order to set up EKS cluster, the following policies must be added to the IAM ROLE:

   AmazonEKSClusterPolicy

   AmazonEKSServicePolicy

   AmazonEKSVPCResourceController

## In order to set up EKS WORKERNODE, the following policies must be added to the IAM ROLE.

   AmazonEKSWorkerNodePolicy

   AmazonEKS_CNI_Policy

   AmazonEC2ContainerRegistryReadOnly

## Script Folder Structure:

a) jenkins-eks
b) terraform-eks

main.tf --> Main configuration file containing resouce definition

variables.tf --> contains variable declarations

outputs.tf --> contains outputs from resources

provider.tf --> contains provider definition

terraform.tf --> configure Terraform behaviour


