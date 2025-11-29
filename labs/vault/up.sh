#!/bin/bash

set -e

VALS_DIR='./config'

function progress() {
  echo "+----------------------------------------------+"
  echo " $1 "
  echo "+----------------------------------------------+"
}

function helmrepo() {
  progress "Updating Helm repos"
  ### helm repo
  helm repo add hashicorp https://helm.releases.hashicorp.com
  helm repo list
  helm repo update
}

function setup() {
  ### apps
  progress "Installing Vault"
  bash ../../scripts/helmctl "deploy" "-c" "./release/vault.yaml"

  ### list deployed helm releases
  progress "Installed applications"
  helm ls -A
}

### main
helmrepo
setup
