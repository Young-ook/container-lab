#!/bin/bash

set -e

VALS_DIR='./config'

function progress() {
  echo "+----------------------------------------------+"
  echo " $1 "
  echo "+----------------------------------------------+"
}

function setup() {
  ### apps
  progress "Installing Devtron"
  bash ../../scripts/helmctl "deploy" "./release/devtron.yaml"

  ### list deployed helm releases
  progress "Installed applications"
  helm ls -A
}

function adminpw() {
  sleep 5;
  progress "Devtron admin initial password:"
  kubectl -n devtroncd get secret devtron-secret \
      -o jsonpath='{.data.ADMIN_PASSWORD}' | base64 -d ; echo
}

### main
setup
adminpw
