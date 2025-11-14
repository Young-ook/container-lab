#!/bin/bash

VALS_DIR='./config'
TENANT_ID=tenant1
TENANT_PW=tenant1

function progress() {
  echo "+----------------------------------------------+"
  echo " $1 "
  echo "+----------------------------------------------+"
}

function helmrepo() {
  progress "Updating Helm repos"
  ### helm repo
  helm repo add grafana https://grafana.github.io/helm-charts
  helm repo list
  helm repo update
}

function setup() {
  ### creds
  for ns in alloy loki mimir monitoring tempo; do
    kubectl create ns $ns
  done

  progress "Generating credentials"
  htpasswd -cb .htpasswd $TENANT_ID $TENANT_PW
  kubectl -n loki create secret generic basic-auth --from-file=.htpasswd
  kubectl -n mimir create secret generic basic-auth --from-file=.htpasswd
  #kubectl -n tempo create secret generic basic-auth --from-file=.htpasswd
  rm .htpasswd

  kubectl -n alloy create secret generic basic-auth \
      --from-literal=username=$TENANT_ID \
      --from-literal=password=$TENANT_PW

  ### apps
  progress "Installing Loki"
  bash ../../../scripts/helmctl.sh "install" "-c" "./release/loki.yaml"

  progress "Installing Mimir"
  bash ../../../scripts/helmctl.sh "install" "-c" "./release/mimir.yaml"

  #progress "Installing Tempo"
  #bash ../../../scripts/helmctl.sh "install" "-c" "./release/tempo.yaml"

  progress "Installing Alloy"
  sed -i "s/TENANT_ID/$TENANT_ID/g" $VALS_DIR/k8s-monitoring.yaml
  bash ../../../scripts/helmctl.sh "install" "-c" "./release/k8s-monitoring.yaml"

  progress "Installing Grafana"
  sed -i "s/TENANT_ID/$TENANT_ID/g" $VALS_DIR/grafana.yaml
  sed -i "s/TENANT_PW/$TENANT_PW/g" $VALS_DIR/grafana.yaml
  bash ../../../scripts/helmctl.sh "install" "-c" "./release/grafana.yaml"

  ### list deployed helm releases
  progress "Installed applications"
  helm ls -A
}

function adminpw() {
  echo "Grafana admin initial password:"
  kubectl get secret --namespace monitoring grafana \
      -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
}

### main
helmrepo
setup
adminpw
