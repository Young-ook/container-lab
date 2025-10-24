#!/bin/bash -e

VALS_DIR='./config'

DEVTRON_CHART_VER=9.2.10


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
  progress "Installing Devtron"
  ### apps
  helm upgrade --install devtron -n devtroncd devtron/devtron-operator \
      --set installer.modules={cicd} \
      --set argo-cd.enabled=true \
      --create-namespace

  ### list deployed helm releases
  progress "Installed applications"
  helm ls -A
}

function adminpw() {
  echo "Devtron admin initial password:"
  kubectl -n devtroncd get secret devtron-secret \
      -o jsonpath='{.data.ADMIN_PASSWORD}' | base64 -d ; echo
}

### main
helmrepo
setup
adminpw
