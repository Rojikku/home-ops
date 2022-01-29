#!/bin/bash
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd "$parent_path"

# Comment as desired
kubectl apply -f deployments/hass.yaml
kubectl apply -f deployments/nodered.yaml
kubectl apply -f deployments/zwavejs.yaml
