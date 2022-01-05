#!/usr/bin/env bash
kubectl apply -f ./cluster/apps/networking/authentik/postgres/postgres-db.yaml
kubectl apply -f ./cluster/apps/hass/home-assistant/postgres-db.yaml
kubectl apply -f ./cluster/apps/monitoring/grafana/postgres-db.yaml
