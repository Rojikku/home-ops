# Stash Restore Instructions

## Restore on Cluster Rebuild
It's kinda gross to have all the apps I want to restore running when I restore them, so I have a busybox template that sleeps for an hour.
Each workloads needs its own deployment, so just base off of that.

There is a script to enable you to easily comment out certain deployments, but you could also deploy the entire folder without the script.



## Tips and Tricks
Any stash BackupConfiguration can be paused with this syntax, but you may need to suspend flux so it doesn't fix it during the restore:
```
kubectl patch backupconfiguration -n demo deployment-backup --type="merge" --patch='{"spec": {"paused": true}}'
```
