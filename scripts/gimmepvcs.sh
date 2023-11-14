#!/bin/bash
kubectl apply -f cluster/apps/hass/zwave/app/config-pvc.yaml
kubectl apply -f cluster/apps/hass/nodered/app/config-pvc.yaml
kubectl apply -f cluster/apps/hass/home-assistant/app/config-pvc.yaml

kubectl apply -f cluster/apps/default/mealie/api/config-pvc.yaml

kubectl apply -f cluster/apps/media/prowlarr/app/config-pvc.yaml
kubectl apply -f cluster/apps/media/qbittorrent/app/config-pvc.yaml
kubectl apply -f cluster/apps/media/sonarr/app/config-pvc.yaml
kubectl apply -f cluster/apps/media/radarr/app/config-pvc.yaml
kubectl apply -f cluster/apps/media/jellyfin/app/config-pvc.yaml
kubectl apply -f cluster/apps/media/ombi/app/config-pvc.yaml
kubectl apply -f cluster/apps/media/aniplanrr/app/config-pvc.yaml

kubectl apply -f cluster/apps/networking/authentik/backup-pvc.yaml
