#!/bin/bash

set -e

VALS_DIR='./config'

function progress() {
  echo "+----------------------------------------------+"
  echo " $1 "
  echo "+----------------------------------------------+"
}

function uninstall() {
  ### apps
  progress "Uninstalling Vault"
  bash ../../scripts/helmctl "uninstall" "-c" "./release/vault.yaml"

  kubectl delete ns vault
}

### main
uninstall

