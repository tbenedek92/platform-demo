######################

# Create the "allow-eks-terraform-admin" IAM policy with the "eks:DescribeCluster" action is to grant the necessary permissions for managing an Amazon EKS cluster##

module "iam_policy_eks_admin_access" {
  source        = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version       = "5.22.0"
  name          = "allow-eks-terraform-admin"
  create_policy = true
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "eks:DescribeCluster",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}
