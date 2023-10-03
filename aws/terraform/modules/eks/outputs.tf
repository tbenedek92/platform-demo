output "eks_managed_node_groups" {
  value = module.eks.eks_managed_node_groups["general"]
}

output "eks_managed_cluster_vpc_config" {
  value = module.eks.cluster_security_group_id
}
