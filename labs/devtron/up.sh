#!/bin/bash -e

VALS_DIR='./config'

function progress() {
  echo "+----------------------------------------------+"
  echo " $1 "
  echo "+----------------------------------------------+"
}

function helmrepo() {
  progress "Updating Helm repos"
  ### helm repo
  helm repo add devtron https://helm.devtron.ai 
  helm repo list
  helm repo update
}

function setup() {
  ### apps
  progress "Installing Devtron"
  bash ../../scripts/helmctl "install" "-c" "./release/devtron.yaml"

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
helmrepo
setup
adminpw
