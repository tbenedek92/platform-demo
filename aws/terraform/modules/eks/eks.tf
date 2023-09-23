resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    subnet_ids = module.vpc.private_subnet_ids
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster,
    # vpc.aws_route_table_association.public  # Ensuring the networking is ready before EKS
  ]
}
