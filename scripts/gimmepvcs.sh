#!/bin/bash
kubectl apply -f cluster/apps/hass/zwave/config-pvc.yaml
kubectl apply -f cluster/apps/hass/nodered/config-pvc.yaml
kubectl apply -f cluster/apps/hass/mosquitto/config-pvc.yaml
kubectl apply -f cluster/apps/hass/home-assistant/config-pvc.yaml
kubectl apply -f cluster/apps/vpn/jackett/config-pvc.yaml
kubectl apply -f cluster/apps/vpn/prowlarr/config-pvc.yaml
kubectl apply -f cluster/apps/vpn/qbittorrent/config-pvc.yaml
kubectl apply -f cluster/apps/vpn/sonarr/config-pvc.yaml
kubectl apply -f cluster/apps/networking/authentik/backup-pvc.yaml
