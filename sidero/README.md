# Sidero

My installation notes based off of [official docs](https://www.sidero.dev/v0.5/guides/sidero-on-rpi4/) (Totally not mostly stolen from onedr0p...really).

## Installing Talos

Download the latest Talos RPi4 image and install it on the SD card
```sh
curl -LO https://github.com/siderolabs/talos/releases/download/latest/metal-rpi_4-arm64.img.xz
xz -d metal-rpi_4-arm64.img.xz
sudo dd if=metal-rpi_4-arm64.img of=/dev/sdc bs=4M conv=fsync status=progress
sudo sync
```

Boot the RPi4. Talos should drop into maintenance mode printing the acquired IP address.
> Note: it makes sense to transform DHCP lease for RPi4 into a static reservation so that RPi4 always has the same IP address.
Mine is a static reservation, already, so I don't have to look it up.
Record the IP address as the environment variable `SIDERO_ENDPOINT`:

```sh
set -gx SIDERO_ENDPOINT 192.168.0.95
```

Generate Talos machine configuration for a single-node cluster:

```sh
talosctl gen config --config-patch='[{"op": "add", "path": "/cluster/allowSchedulingOnMasters", "value": true},{"op": "replace", "path": "/machine/install/disk", "value": "/dev/mmcblk0"},{"op": "replace", "path": "/machine/kubelet/image", "value": "ghcr.io/siderolabs/kubelet:v1.26.0"}]' sidero https://$SIDERO_ENDPOINT:6443/
```

In `controlplane.yaml` uncomment and change all Kubernetes images to use `v1.22.0` and talos image to `v0.13.0`

Submit the generated configuration to Talos:

```sh
talosctl apply-config --insecure -n $SIDERO_ENDPOINT -f controlplane.yaml
```

Merge client configuration `talosconfig` into default `~/.talos/config` location:

```sh
talosctl config merge talosconfig
```

Update default endpoint and nodes:

```sh
talosctl config endpoints $SIDERO_ENDPOINT
talosctl config nodes $SIDERO_ENDPOINT
```

You can verify that Talos has booted by running:

```sh
talosctl version
```

<!-- Bootstrap the etcd cluster:

```sh
talosctl bootstrap
``` -->

Fetch the `kubeconfig` from the cluster with:

```sh
talosctl kubeconfig
```

You can watch the bootstrap progress by running:

```sh
talosctl dmesg -f
```

Once Talos prints `[talos] boot sequence: done`, Kubernetes should be up:

```sh
kubectl get nodes
```

# Sidero Install via ClusterCTL
Install the configuration file `clusterctl.yaml` with configuration options, or specify --config, and run:
```sh
clusterctl init -b talos -c talos -i sidero
```

(If needed) Patch the deployment to enable host networking:

```sh
kubectl patch deploy -n sidero-system sidero-controller-manager --type='json' -p='[{"op": "add", "path": "/spec/template/spec/hostNetwork", "value": true}]'
```

## Setup for the cluster

Apply the ServerClass for control planes.

Then patch any remaining nodes as needed.

```sh
kubectl patch server $UID --type='json' -p='[{"op": "replace", "path": "/machine/install", "value": {"disk": "/dev/sda"} }]'
```

```sh
kubectl patch server $UID --type='json' -p='[{"op": "replace", "path": "/spec/accepted", "value": true}]'
```

## Generate cluster configs

Generate cluster configuration:
```sh
CONTROL_PLANE_SERVERCLASS=controlplane \
WORKER_SERVERCLASS=any \
TALOS_VERSION=v0.14.1 \
KUBERNETES_VERSION=v1.23.3 \
CONTROL_PLANE_PORT=6443 \
CONTROL_PLANE_ENDPOINT=192.168.0.90 \
clusterctl generate cluster cluster-0 -i sidero > cluster-0.yaml
```

Setup talos VIP as directed [here](https://www.sidero.dev/docs/v0.4/resource-configuration/metadata/#talos-machine-configuration).

Edit the cluster-0.yaml for the appropriate replica counts.

## Deploy

```sh
kubectl apply -f cluster-0.yaml
```

```sh
watch kubectl get servers,machines,clusters
```


## Control with Talosctl

Get the talosconfig:
```sh
kubectl --context=sidero-demo \
  get talosconfig \
  -l cluster.x-k8s.io/cluster-name=cluster-0 \
  -o jsonpath='{.items[0].status.talosConfig}' \
  > cluster-0-talosconfig.yaml
```

You may then import kubeconfig like so:
```sh
talosctl --talosconfig cluster-0.yaml kubeconfig
```
