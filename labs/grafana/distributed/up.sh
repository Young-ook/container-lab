#!/bin/bash

VALS_DIR='./config'
TENANT_ID=tenant1
TENANT_PW=tenant1

GRAFANA_CHART_VER=9.2.10
K8SMON_CHART_VER=3.1.2
LOKI_CHART_VER=6.31.0
MIMIR_CHART_VER=5.7.0
TEMPO_CHART_VER=1.45.0

function helmrepo() {
  echo "Updating Helm repos"
  ### helm repo
  helm repo add grafana https://grafana.github.io/helm-charts
  helm repo list
  helm repo update
}

function setup() {
  echo "Installing applications"

  ### creds
  for ns in alloy loki mimir monitoring tempo; do
    kubectl create ns $ns
  done

  htpasswd -cb .htpasswd $TENANT_ID $TENANT_PW
  kubectl -n loki create secret generic basic-auth --from-file=.htpasswd
  kubectl -n mimir create secret generic basic-auth --from-file=.htpasswd
#  kubectl -n tempo create secret generic basic-auth --from-file=.htpasswd
  rm .htpasswd

  kubectl -n alloy create secret generic basic-auth \
      --from-literal=username=$TENANT_ID \
      --from-literal=password=$TENANT_PW

  ### apps
  helm upgrade --install -n loki loki grafana/loki \
      -f $VALS_DIR/loki.yaml --version $LOKI_CHART_VER \
      --create-namespace
  helm upgrade --install -n mimir mimir grafana/mimir-distributed \
      -f $VALS_DIR/mimir.yaml --version $MIMIR_CHART_VER \
      --create-namespace
#  helm upgrade --install -n tempo tempo grafana/tempo-distributed -f $VALS_DIR/tempo.yaml --version ${TEMPO_CHART_VER} --create-namespace

  helm upgrade --install -n monitoring grafana grafana/grafana \
      -f $VALS_DIR/grafana.yaml --version $GRAFANA_CHART_VER \
      --create-namespace

  helm upgrade --install -n alloy k8s-monitoring grafana/k8s-monitoring \
      -f $VALS_DIR/alloy.yaml --version $K8SMON_CHART_VER
}

# main
helmrepo
setup
