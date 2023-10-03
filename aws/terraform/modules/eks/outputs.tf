output "eks_managed_node_groups" {
  value = module.eks.eks_managed_node_groups["general"]
}
