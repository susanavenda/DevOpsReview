provider "aws" {
  region = "us-west-2"
}

module "vpc" {
  source      = "../modules/vpc"
  provider    = "aws"
  cidr_block  = "10.0.0.0/16"
}

resource "aws_eks_cluster" "k8s_cluster" {
  name     = "my-cluster"
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids = [module.vpc.subnet_id]
  }
}

resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.k8s_cluster.name
  node_group_name = "my-node-group"
  node_role_arn   = aws_iam_role.eks_node.arn

  scaling_config {
    desired_size = 3
    max_size     = 5
    min_size     = 1
  }

  subnet_ids = [module.vpc.subnet_id]
}