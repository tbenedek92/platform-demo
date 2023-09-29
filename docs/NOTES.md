# Troubleshoot node groups

### Delete node group from AWS CLI
```
aws eks delete-nodegroup --cluster-name tooling-cluster   --nodegroup-name tooling-node-group  --region eu-central-1
```

## Troubleshooting IP address assignment issue

By default AWS limits the number of ip addresses that can be assigned to a node. As in this project I use pretty small nodes (t3.micro) there can be only 4 IP addresses assigned to a node. Considering the 2 daemonset pods that are running by default on each k8s node, and the IP assigned to the node itself, I have only 1 IP address remaining, meaning each node can run only a single pod.

The max number of IP addresses per machine can be found [here]
(https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-eni.html#AvailableIpPerENI).

The above case is detailed [here](https://aws.amazon.com/blogs/containers/amazon-vpc-cni-increases-pods-per-node-limits/)

Use the parameter ENABLE_PREFIX_DELEGATION to configure the VPC CNI plugin to assign prefixes to network interfaces.

### Enabling prefix assignment mode
TLDR: Enabling prefix assignment mode resolves the issue.

```
kubectl set env daemonset aws-node -n kube-system ENABLE_PREFIX_DELEGATION=true
```

Confirm if environment variable is set.
```
kubectl describe daemonset -n kube-system aws-node | grep ENABLE_PREFIX_DELEGATION
```
### Scale faster, preserve IPv4 addresses

I leave it here, just because it is interesting how horizontal scaling can be sped-up.

With the default setting, WARM_PREFIX_TARGET will allocate one additional complete (/28) prefix even if the existing prefix is used by only one pod. 
```
kubectl set env ds aws-node -n kube-system WARM_PREFIX_TARGET=1
```
