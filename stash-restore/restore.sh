#!/bin/bash
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd "$parent_path"

# Comment as desired
kubectl apply -f restores/hass.yaml
kubectl apply -f restores/nodered.yaml
kubectl apply -f restores/zwavejs.yaml
