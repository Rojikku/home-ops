# Bootstrap

## Flux

### Install Flux

```sh
kubectl apply --server-side --kustomize ./cluster/bootstrap/flux
```

### Apply Cluster Configuration

_These cannot be applied with `kubectl` in the regular fashion due to be encrypted with sops_

```sh
sops -d cluster/bootstrap/flux/age-key.sops.yaml | kubectl apply -f -
sops -d cluster/bootstrap/flux/github-deploy-key.sops.yaml | kubectl apply -f -
sops -d cluster/flux/vars/cluster-secrets.sops.yaml | kubectl apply -f -
kubectl apply -f cluster/flux/vars/cluster-settings.yaml
```

### Kick off Flux applying this repository

```sh
kubectl apply --server-side --kustomize ./cluster/flux/config
```
