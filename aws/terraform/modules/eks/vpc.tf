module "vpc" {
  source = "../vpc"
  
  # vpc_id = module.vpc.vpc_id
  # iam_role_arn = module.iam_roles.eks_role_arn
}
