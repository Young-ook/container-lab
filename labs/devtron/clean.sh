#!/bin/bash

helm uninstall -n devtroncd devtron

kubectl delete ns argo devtron-ci devtron-cd devtron-demo devtroncd
