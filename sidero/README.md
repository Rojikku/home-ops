# Sidero

My installation notes based off of [official docs](https://www.sidero.dev/v0.5/guides/sidero-on-rpi4/) (Totally not mostly stolen from onedr0p...really).

## Installing Talos

Download the latest Talos RPi4 image and install it on the SD card
```sh
curl -LO https://github.com/siderolabs/talos/releases/download/v1.5.5/metal-rpi_generic-arm64.raw.xz
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
talosctl gen config --config-patch='[{"op": "add", "path": "/cluster/allowSchedulingOnMasters", "value": true},{"op": "replace", "path": "/machine/install/disk", "value": "/dev/mmcblk0"},{"op": "replace", "path": "/machine/kubelet/image", "value": "ghcr.io/siderolabs/kubelet:v1.28.3"}]' sidero https://$SIDERO_ENDPOINT:6443/
```
Optionally, if talosctl recently updated, you can not set the latest kubelet version and it'll autocomplete.
Talosctl must be up to date to generate with the latest version of talos images.

I recommend going into `controlplane.yaml` and uncommenting the time subsection.
The configs can have significant updates and improvements, so if you're reinstalling the system anyway, it makes sense to generate a new config.

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

Bootstrap the etcd cluster:

```sh
talosctl bootstrap
```

Fetch the `kubeconfig` from the cluster with:

```sh
talosctl kubeconfig
```

Since I have multiple clusters, I use kubie. Change to the appropriate context if needed.
```sh
kubie ctx
```

You can watch the bootstrap progress by running:

```sh
talosctl dmesg -f
```

Once Talos prints `[talos] boot sequence: done`, Kubernetes should be up:

```sh
kubectl get nodes
```

# Setup flux
It's nice to use flux/github/renovate to keep my cluster configs up to date.

Might want to disable the sidero/clusterConfig/kustomization.yaml for cluster-0 so it doesn't start doing things on its own, though.

[Apply the bootstrap](/cluster/bootstrap/readme.md)

# Sidero Install via ClusterCTL
Install the configuration file `clusterctl.yaml` with configuration options, or specify --config, and run:
```sh
clusterctl --config clusterctl.yaml init -b talos -c talos -i sidero
```

(If needed) Patch the deployment to enable host networking:

```sh
kubectl patch deploy -n sidero-system sidero-controller-manager --type='json' -p='[{"op": "add", "path": "/spec/template/spec/hostNetwork", "value": true}]'
```


## Generate cluster configs

If needed, otherwise use existing configs synced with flux

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

## Setup for the cluster

Apply the ServerClass for control planes.

Then patch any remaining nodes as needed.

```sh
kubectl patch server $UID --type='json' -p='[{"op": "replace", "path": "/machine/install", "value": {"disk": "/dev/sda"} }]'
```

```sh
kubectl patch server $UID --type='json' -p='[{"op": "replace", "path": "/spec/accepted", "value": true}]'
```

## Setup the nodes

I like to use theila to view my Servers, and then I PXE boot every node one by one, accept the server in theila, and sidero will wipe them all. Once I have all of them wiped, then I will proceed to the next step.

## Deploy

```sh
kubectl apply -f cluster-0.yaml
```
Or enable it again in flux

```sh
watch kubectl get servers,machines,clusters
```


## Control with Talosctl

Get the talosconfig:
```sh
kubectl \
  get talosconfig \
  -l cluster.x-k8s.io/cluster-name=cluster-0 \
  -o jsonpath='{.items[0].status.talosConfig}' \
  > cluster-0-talosconfig.yaml
  talosctl config merge cluster-0-talosconfig.yaml
```

Set the nodes/endpoints
```sh
talosctl config endpoints 192.168.0.100 192.168.0.101 192.168.0.102
talosctl config nodes 192.168.0.100 192.168.0.101 192.168.0.102 192.168.0.103 192.168.0.104 192.168.0.105
```

You may then import kubeconfig like so:
```sh
talosctl kubeconfig
```
