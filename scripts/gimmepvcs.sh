#!/bin/bash
kubectl apply -f cluster/apps/hass/zwave/config-pvc.yaml
kubectl apply -f cluster/apps/hass/nodered/config-pvc.yaml
kubectl apply -f cluster/apps/hass/mosquitto/config-pvc.yaml
kubectl apply -f cluster/apps/hass/home-assistant/config-pvc.yaml

kubectl apply -f cluster/apps/media/prowlarr/config-pvc.yaml
kubectl apply -f cluster/apps/media/qbittorrent/config-pvc.yaml
kubectl apply -f cluster/apps/media/sonarr/config-pvc.yaml
kubectl apply -f cluster/apps/media/jellyfin/config-pvc.yaml
kubectl apply -f cluster/apps/media/ombi/config-pvc.yaml

kubectl apply -f cluster/apps/networking/authentik/backup-pvc.yaml
