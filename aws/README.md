## What happens here?

Running  `terraform apply` provisions an EKS cluster and required network components for it.
1 subnet with:
- 2 private subnet
- 2 public subnets

### How to manually connect to the provisioned cluster 

```
aws eks update-kubeconfig --region region eu-central-1 --name tooling-cluster --
```

