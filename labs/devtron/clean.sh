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

  kubectl delete ns argo devtron-ci devtron-cd devtron-demo devtroncd
}

### main
uninstall

