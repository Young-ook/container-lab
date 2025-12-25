#!/bin/bash

set -e

VALS_DIR='./config'

function progress() {
  echo "+----------------------------------------------+"
  echo " $1 "
  echo "+----------------------------------------------+"
}

function init() {
  progress "Enable KV v2 Secret Engine in Vault"

  ### secret access
  kubectl exec -n vault vault-0 -- \
    vault secrets enable -path=kvv2 kv-v2

  kubectl exec -i -n vault vault-0 -- \
    vault policy write webapp-secret-policy - <<EOF
path "kvv2/data/webapp/config" {
   capabilities = ["read", "list"]
}
EOF

  kubectl exec -n vault vault-0 -- \
    vault write auth/demo-kube/role/app-role1 \
      bound_service_account_names=webapp-manager \
      bound_service_account_namespaces=webapp \
      policies=webapp-secret-policy \
      audience=vault \
      ttl=24h
}

function synckv() {
  ### create a new secret
  kubectl exec -n vault vault-0 -- \
    vault kv put kvv2/webapp/config username="demouser" password="demopassword"

  ### create a vault static secret to sync vault kv secret and kubernetes secret
  kubectl apply -f secret/vaultkv.yaml
}

### main
init
synckv
