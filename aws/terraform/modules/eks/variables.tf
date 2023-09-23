variable "aws_region" {
  default = "eu-central-1"
  description = "AWS region to launch resources in."
}

variable "cluster_name" {
  default = "tooling-cluster"
  description = "eks cluster's name"
}
