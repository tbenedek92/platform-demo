# ArgoCD setup

This folder contains all ArgoCD specific manifests.

## Bootstrapping ArgoCD
With this approach any ArgoCD manifest from `main` branch in this repository under the `aws/argocd` folder is monitored and picked up automatically.

## Folder structure

### Applications
Contains ArgoCD application manifests for each app, that should be monitored & deployed by ArgoCD. 
The argo-bootstrap.yaml is used to monitor all resources under `aws/argocd`.

### Projects
Contains ArgoCD project manifests.

### Repos
Contains ArgoCD repository manifests for git & helm repositories.
