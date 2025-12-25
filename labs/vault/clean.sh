#!/bin/bash

VALS_DIR='./config'

function progress() {
  echo "+----------------------------------------------+"
  echo " $1 "
  echo "+----------------------------------------------+"
}

function uninstall() {
  ### remove demo
  kubectl delete -f secret/vaultkv.yaml

  ### apps
  progress "Uninstalling Vault Secrets Operator"
  bash ../../scripts/helmctl "uninstall" "./release/vault-secrets-operator.yaml"

  progress "Uninstalling Vault"
  bash ../../scripts/helmctl "uninstall" "./release/vault.yaml"

  kubectl get crd -o name | grep "secrets.hashicorp.com" | xargs -r kubectl delete
  kubectl delete ns vault vault-secrets-operator-system
}

### main
uninstall

