module "eks_cluster" {
  source = "../../modules/eks"
  
  aws_region = var.aws_region
  cluster_name = var.cluster_name
  eks_tags = var.eks_tags
  node_group_min_size = var.node_group_min_size
  node_group_max_size = var.node_group_max_size
  node_group_desired_size = var.node_group_desired_size
  network_name = var.network_name
}
