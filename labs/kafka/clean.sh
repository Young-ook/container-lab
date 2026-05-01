#!/bin/bash

VALS_DIR='./config'

function progress() {
  echo "+----------------------------------------------+"
  echo " $1 "
  echo "+----------------------------------------------+"
}

function uninstall() {
  ### apps
  progress "Uninstalling Kafka"
  bash ../../scripts/helmctl "uninstall" "./release/kafka.yaml"

  progress "Eliminating Namespaces"
  kubectl delete ns kafka
}

### main
uninstall

