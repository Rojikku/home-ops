#!/bin/bash
kubectl apply -f cluster/apps/hass/zwave/config-pvc.yaml
kubectl apply -f cluster/apps/hass/nodered/config-pvc.yaml
kubectl apply -f cluster/apps/hass/mosquitto/config-pvc.yaml
kubectl apply -f cluster/apps/hass/home-assistant/config-pvc.yaml
