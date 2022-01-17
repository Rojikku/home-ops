# Stash Restore Instructions
Any stash BackupConfiguration can be paused with this syntax, but you may need to suspend flux so it doesn't fix it during the restore:
```
kubectl patch backupconfiguration -n demo deployment-backup --type="merge" --patch='{"spec": {"paused": true}}'
```
