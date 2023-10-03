# platform-demo

## Current state

GitHub Action pipeline can:
- Provision an EKS cluster using terraform
  - Deploys the neccessary network components
  - Deploys a managed node group
  - Deploys EKS resource
- Authenticate to k8s
- Install ArgoCD
- Boostrap ArgoCD, which installs
  - Install further cluster components:
    - ingress-nginx
    - metrics-server
    - crossplane
    - sealed-secrets
- Bootstrap crossplane resources:
  - provider
  - provide-config
  - demo resource-group

# Next steps
- Setup Azure resources with Crossplane
- Deploy a demo application with ArgoCD to Azure cluster, using resources provisioned by Crossplane on-demand

## Goal
My goal with this project is to create a small platform leveraging cloud providers:
- Provision an EKS cluster with terraform
- Deploy ArgoCD into the cluster
  - Bootstrap ArgoCD
- ArgoCD to Deploy CrossPlane and CrossPlane resources

## Usage of ArgoCD & CrossPlane
Build a GitOps based platform that can deploy applications and cloud resources for them on-demand
