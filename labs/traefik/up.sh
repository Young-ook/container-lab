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
  helm repo add traefik https://traefik.github.io/charts
  helm repo list
  helm repo update
}

function setup() {
  ### apps
  progress "Installing Traefik"
  bash ../../scripts/helmctl "deploy" "./release/traefik.yaml"

  ### list deployed helm releases
  progress "Installed applications"
  helm ls -A
}

### main
helmrepo
setup

