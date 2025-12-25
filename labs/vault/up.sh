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

  progress "Installing Vault Secrets Operator"
  bash ../../scripts/helmctl "deploy" "-c" "./release/vault-secrets-operator.yaml"

  ### list deployed helm releases
  progress "Installed applications"
  helm ls -A
}

function init() {
  ### vault auth and secret initialization
  local wait=60

  progress "Waiting ${wait}s for Vault server bootsrappting"
  sleep $wait

  progress "Initialize Vault"

  ### vault access auth
  kubectl exec -n vault vault-0 -- \
    vault secrets enable -path=demo-transit transit

  kubectl exec -n vault vault-0 -- \
    vault write -force demo-transit/keys/vso-client-cache

  kubectl exec -i -n vault vault-0 -- \
  vault policy write demo-kube-auth-policy - <<EOF
path "demo-transit/encrypt/vso-client-cache" {
   capabilities = ["create", "update"]
}
path "demo-transit/decrypt/vso-client-cache" {
   capabilities = ["create", "update"]
}
EOF

  kubectl exec -n vault vault-0 -- \
    vault auth enable -path=demo-kube kubernetes

  KUBERNETES_HOST="https://kubernetes.default.svc"
  kubectl exec -n vault vault-0 -- \
    vault write auth/demo-kube/config \
      kubernetes_host="$KUBERNETES_HOST"

  kubectl exec -n vault vault-0 -- \
    vault write auth/demo-kube/config \

  kubectl exec -n vault vault-0 -- \
    vault write auth/demo-kube/role/vso-role \
      bound_service_account_names=vault-secrets-operator-controller-manager \
      bound_service_account_namespaces=vault-secrets-operator-system \
      token_ttl=0 \
      token_period=120 \
      token_policies=demo-kube-auth-policy \
      audience=vault
}

### main
helmrepo
setup
init
