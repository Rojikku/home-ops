# Sidero

My installation notes based off of [official docs](https://www.sidero.dev/docs/v0.3/guides/sidero-on-rpi4/) (Totally not mostly stolen from onedr0p...really).

## Installing Talos

Prepare the SD card with the Talos RPi4 image, and boot the RPi4. Talos should drop into maintenance mode printing the acquired IP address. Record the IP address as the environment variable `SIDERO_ENDPOINT`:

```sh
set -gx SIDERO_ENDPOINT 192.168.42.179
```

> Note: it makes sense to transform DHCP lease for RPi4 into a static reservation so that RPi4 always has the same IP address.
Generate Talos machine configuration for a single-node cluster:

```sh
talosctl gen config \
    --config-patch='[{"op": "add", "path": "/cluster/allowSchedulingOnMasters", "value": true},{"op": "replace", "path": "/machine/install/disk", "value": "/dev/mmcblk0"}]' \
    sidero https://$SIDERO_ENDPOINT:6443/
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

# Control with Talosctl

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
