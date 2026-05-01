#!/bin/bash

set -e

VALS_DIR='./config'

function progress() {
  echo "+----------------------------------------------+"
  echo " $1 "
  echo "+----------------------------------------------+"
}

function setup() {
  ### apps
  # install kafka broker
  progress "Installing Kafka"
  echo "✓ $(bash ../../scripts/helmctl version)"
  bash ../../scripts/helmctl "deploy" "./release/kafka.yaml"

  ### list deployed helm releases
  progress "Installed applications"
  helm ls -A
}

### main
setup

