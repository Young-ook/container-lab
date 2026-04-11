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
  # istio-base chart which contains clsuter-wide CRDs which must be installed prior to the istio control-plane.
  # istio-gateway is a chart to support istio ingress/egress gateways management.
  progress "Installing Istio"
  echo "✓ $(bash ../../scripts/helmctl version)"

  bash ../../scripts/helmctl "deploy" "./release/istio-base.yaml"
  bash ../../scripts/helmctl "deploy" "./release/istiod.yaml"

  # istio ingress and egress gateways are optional components to controll in/out-bound traffics.
  # you can use loadbalaner or any other network appliances for external communication.
  bash ../../scripts/helmctl "deploy" "./release/istio-ingressgateway.yaml"
  bash ../../scripts/helmctl "deploy" "./release/istio-egressgateway.yaml"

  ### list deployed helm releases
  progress "Installed applications"
  helm ls -A
}

function config() {
  ### apps
  progress "Enable sidecar injection"
  kubectl create namespace bookinfo
  kubectl label namespace bookinfo istio-injection=enabled
}

### main
setup
config

