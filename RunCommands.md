# Log of Run Commands to get to cluster state

Fix Two Default Storage Classes  (I no longer install local-path)
```
kubectl patch storageclass local-path -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"false"}}}'
```

## Manually run cronjob
```
kubectl create job --from=cronjob/<name of cronjob> <name of job>
```

## How to add a node back to cluster
Use the normal k3s-install, but specify `k3s_control_token:` in `kubernetes/k3s.yml`

## How to replace and readd an OSD back to the cluster
1. Comment out the node from the code and reconcile that change  
2. Purge the OSD with the web UI or `ceph osd purge osd.ID --yes-i-really-mean-it`  
3. Delete the job and deployment of the node  
4. Using the toolbox, run `ceph auth del osd.ID` or you will get an error about the key already existing  
5. Uncomment the node from code, changing as neaded, and reconcile that change to readd the node.  

## Setup RPI 4 to boot from USB
[Guide](https://jamesachambers.com/raspberry-pi-4-ubuntu-20-04-usb-mass-storage-boot-guide/) - Firmware update not needed

## Get creds
To login to minio-operator with JWT  
`kubectl -n minio get secret (kubectl -n minio get serviceaccount console-sa -o jsonpath="{.secrets[0].name}") -o jsonpath="{.data.token}" | base64 --decode`

To login to rook-ceph  
`kubectl -n rook-ceph get secret rook-ceph-dashboard-password -o jsonpath="{['data']['password']}" | base64 --decode && echo`
