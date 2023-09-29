# ArgoCD deployment

Basic deployment of ArgoCD, with values configured for ingress with path `/argocd`.

### How to deploy?

```
helm upgrade --install argocd -n argocd argo/argo-cd -f values.yaml 
```
