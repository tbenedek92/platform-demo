module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.28"

  cluster_endpoint_private_access = true 
  cluster_endpoint_public_access  = true  

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids

  enable_irsa = false


  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  eks_managed_node_group_defaults = {
    disk_size = 20
  }

  eks_managed_node_groups = {
    general = {
      min_size     = 2
      max_size     = 10
      desired_size = 8
      labels = {
        role = "general"
      }

      instance_types = ["t3.micro"]
      capacity_type  = "ON_DEMAND"
    }

  }
  # create_aws_auth_configmap = true 
  manage_aws_auth_configmap = true

  # TODO: replace with a group
  aws_auth_roles = [
    {
      rolearn  = "arn:aws:iam::570775155304:role/AWSReservedSSO_AdministratorAccess_cda24081429f1c83"
      username = "AWSReservedSSO_AdministratorAccess_cda24081429f1c83"
      groups   = ["system:masters"]
    },
  ]

  tags = var.eks_tags
}

# data "aws_eks_cluster_auth" "cluster" {
#   name = module.eks.cluster_name
# }

# provider "kubernetes" {
#   host                   = module.eks.cluster_endpoint
#   cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
#   token                  = data.aws_eks_cluster_auth.cluster.token
#   exec {
#     api_version = "client.authentication.k8s.io/v1beta1"
#     args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name ]
#     command     = "aws"
#   }
# }


# security group to enable kubeseal
resource "aws_security_group_rule" "allow_eks_cluster_to_node_on_8080" {
  type        = "ingress"
  from_port   = 8080
  to_port     = 8080
  protocol    = "tcp"

  security_group_id = module.eks.node_security_group_id
  source_security_group_id = module.eks.cluster_security_group_id
}
