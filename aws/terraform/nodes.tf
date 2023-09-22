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

resource "aws_iam_role" "eks-node-group" {
  name = local.node_group_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks-worker-node-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks-node-group.name
}

resource "aws_iam_role_policy_attachment" "eks-ecr-readonly-policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks-node-group.name
}

data "aws_iam_policy_document" "custom_eks_node_policy_doc" {
  statement {
    actions = [
      "ec2:DescribeInstances",
      "ec2:DescribeNetworkInterfaces",
      "ec2:CreateNetworkInterface",
      "ec2:AttachNetworkInterface",
      "ec2:DeleteNetworkInterface",
      "ec2:DetachNetworkInterface",
      "ec2:AssignPrivateIpAddresses",
      "ec2:UnassignPrivateIpAddresses",
      "ec2:CreateTags" 
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "custom_eks_node_policy" {
  name        = "custom-eks-node-policy"
  description = "Custom policy for additional EKS Node permissions"
  policy      = data.aws_iam_policy_document.custom_eks_node_policy_doc.json
}

# Attach the custom policy to the existing IAM Role
resource "aws_iam_role_policy_attachment" "custom-eks-node-policy" {
  policy_arn = aws_iam_policy.custom_eks_node_policy.arn
  role       = aws_iam_role.eks-node-group.name
}
