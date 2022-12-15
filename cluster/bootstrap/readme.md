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
```

For main cluster
```sh
sops -d cluster/flux/vars/cluster-secrets.sops.yaml | kubectl apply -f -
kubectl apply -f cluster/flux/vars/cluster-settings.yaml
```

Alternatively, install a different cluster, like my sidero
```sh
sops -d sidero/flux/vars/cluster-secrets.sops.yaml | kubectl apply -f -
kubectl apply -f sidero/flux/vars/cluster-settings.yaml
kubectl apply --server-side --kustomize ./sidero/flux/config
```

### Kick off Flux applying this repository

```sh
kubectl apply --server-side --kustomize ./cluster/flux/config
```
