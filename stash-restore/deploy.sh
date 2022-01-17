#!/bin/bash
# Comment as desired
kubectl apply -f deployments/hass.yaml
kubectl apply -f deployments/nodered.yaml
kubectl apply -f deployments/zwavejs.yaml
