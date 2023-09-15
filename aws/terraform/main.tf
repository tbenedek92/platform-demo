provider "aws" {
  region = var.aws_region
}

locals {
  cluster_name = "tooling-cluster"
}
