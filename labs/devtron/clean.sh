#!/bin/bash

VALS_DIR='./config'

function progress() {
  echo "+----------------------------------------------+"
  echo " $1 "
  echo "+----------------------------------------------+"
}

function uninstall() {
  ### apps
  progress "Uninstalling Devtron"
  bash ../../scripts/helmctl "uninstall" "./release/devtron.yaml"

  progress "Removing CRDs"
  kubectl get crd -o name | grep "argoproj.io" | xargs -r kubectl delete --ignore-not-found
  kubectl get crd -o name | grep "devtron.ai" | xargs -r kubectl delete --ignore-not-found

  kubectl delete ns argo devtron-ci devtron-cd devtron-demo devtroncd
}

### main
uninstall

