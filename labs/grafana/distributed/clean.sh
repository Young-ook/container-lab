#!/bin/bash

VALS_DIR='./config'

function progress() {
  echo "+----------------------------------------------+"
  echo " $1 "
  echo "+----------------------------------------------+"
}

function uninstall() {
  ### apps
  progress "Uninstalling k8s monitoring"
  helm uninstall -n alloy k8s-monitoring --cascade foreground

  progress "Uninstalling Grafana"
  bash ../../../scripts/helmctl "uninstall" "./release/grafana.yaml"

  progress "Uninstalling Loki"
  bash ../../../scripts/helmctl "uninstall" "./release/loki.yaml"

  progress "Uninstalling Mimir"
  bash ../../../scripts/helmctl "uninstall" "./release/mimir.yaml"

  #progress "Uninstalling Tempo"
  #bash ../../../scripts/helmctl "uninstall" "./release/tempo.yaml"

  progress "Eliminating namespaces"
  kubectl delete ns alloy loki mimir monitoring tempo
}

### main
uninstall

