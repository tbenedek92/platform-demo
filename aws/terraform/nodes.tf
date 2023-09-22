locals {
  node_group_name = "tooling-node-group"
}

resource "aws_eks_node_group" "tooling-nodes" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = local.node_group_name
  node_role_arn   = aws_iam_role.eks-node-group.arn
  subnet_ids      = aws_subnet.private.*.id

  scaling_config {
    desired_size = 5
    max_size     = 10
    min_size     = 1
  }

  instance_types = ["t3.micro"]

  depends_on = [
    aws_eks_cluster.this,
    aws_iam_role_policy_attachment.eks-worker-node-policy,
    aws_iam_role_policy_attachment.eks-ecr-readonly-policy,
    aws_iam_role_policy_attachment.custom-eks-node-policy,
  ]
}

