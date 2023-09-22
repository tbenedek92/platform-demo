## What happens here?

Running  `terraform apply` provisions an EKS cluster and required network components for it.
1 subnet with:
- 2 private subnet
- 2 public subnets

### How to manually connect to the provisioned cluster 

```
aws eks update-kubeconfig --region region eu-central-1 --name tooling-cluster --
```

Use the parameter ENABLE_PREFIX_DELEGATION to configure the VPC CNI plugin to assign prefixes to network interfaces.

```
kubectl set env daemonset aws-node -n kube-system ENABLE_PREFIX_DELEGATION=true
```

Confirm if environment variable is set.
```
kubectl describe daemonset -n kube-system aws-node | grep ENABLE_PREFIX_DELEGATION
```

With the default setting, WARM_PREFIX_TARGET will allocate one additional complete (/28) prefix even if the existing prefix is used by only one pod. 
```
kubectl set env ds aws-node -n kube-system WARM_PREFIX_TARGET=1
```
