#!/bin/bash

VALS_DIR='./config'

function progress() {
  echo "+----------------------------------------------+"
  echo " $1 "
  echo "+----------------------------------------------+"
}

function uninstall() {
  ### remove demo examples
  #

  ### apps
  progress "Uninstalling Traefik"
  bash ../../scripts/helmctl "uninstall" "./release/traefik.yaml"

  progress "Removing CRDs"
  kubectl get crd -o name | grep "traefik.io" | xargs -r kubectl delete --ignore-not-found

  #crds=$(kubectl get crd -o name | grep -E 'traefik\.io$' || true)
  #if [ -n "$crds" ]; then
  #  kubectl delete $crds --ignore-not-found
  #fi

  progress "Eliminating Namespaces"
  kubectl delete ns traefik
}

### main
uninstall

