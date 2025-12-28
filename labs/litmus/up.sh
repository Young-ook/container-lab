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
  helm repo add litmuschaos https://litmuschaos.github.io/litmus-helm/
  helm repo list
  helm repo update
}

function setup() {
  ### apps
  progress "Installing Litmus"
  bash ../../scripts/helmctl "deploy" "./release/litmus.yaml"

  ### list deployed helm releases
  progress "Installed applications"
  helm ls -A
}

### main
helmrepo
setup
