#!/bin/bash

VALS_DIR='./config'

function progress() {
  echo "+----------------------------------------------+"
  echo " $1 "
  echo "+----------------------------------------------+"
}

function uninstall() {
  ### apps
  progress "Uninstalling Istio"
  bash ../../scripts/helmctl "uninstall" "./release/istio-egressgateway.yaml"
  bash ../../scripts/helmctl "uninstall" "./release/istio-ingressgateway.yaml"
  bash ../../scripts/helmctl "uninstall" "./release/istiod.yaml"
  bash ../../scripts/helmctl "uninstall" "./release/istio-base.yaml"

  progress "Removing CRDs"
  kubectl get crd -o name | grep "istio.io" | xargs -r kubectl delete --ignore-not-found

  progress "Eliminating Namespaces"
  kubectl delete ns istio-system bookinfo
}

### main
uninstall

