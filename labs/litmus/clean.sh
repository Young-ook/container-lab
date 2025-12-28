#!/bin/bash

VALS_DIR='./config'

function progress() {
  echo "+----------------------------------------------+"
  echo " $1 "
  echo "+----------------------------------------------+"
}

function uninstall() {
  ### remove demo

  ### apps
  progress "Uninstalling Litmus"
  bash ../../scripts/helmctl "uninstall" "./release/litmus.yaml"

  progress "Eliminating Namespaces"
  kubectl delete ns litmus
}

### main
uninstall

