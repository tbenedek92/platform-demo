variable "aws_region" {
  default = "eu-central-1"
  description = "AWS region to launch resources in."
}

variable "cluster_name" {
  default = "tooling-cluster"
  description = "eks cluster's name"
}

variable "eks_tags" {
  default     = {}
  description = "Resource tags"
  type        = map(string)
}

variable "node_group_min_size" {
  type = number
  description = "Min size of the nodegroup deployed k8s cluster"
  default = 2
}

variable "node_group_max_size" {
  type = number
  description = "Max size of the nodegroup deployed k8s cluster"
  default = 8
}

variable "node_group_desired_size" {
  type = number
  description = "Desired size of the nodegroup deployed k8s cluster"
  default = 5
}

variable "network_name" {
  default = "platform-demo-eks-vpc"
}
