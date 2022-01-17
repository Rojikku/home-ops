#!/bin/bash
# Comment as desired
kubectl apply -f restores/hass.yaml
kubectl apply -f restores/nodered.yaml
kubectl apply -f restores/zwavejs.yaml
