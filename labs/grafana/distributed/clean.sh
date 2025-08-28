#!/bin/bash

helm uninstall -n alloy k8s-monitoring --cascade foreground
kubectl -n alloy delete secret basic-auth

helm uninstall -n monitoring grafana

helm uninstall -n loki loki
kubectl -n loki delete secret basic-auth

helm uninstall -n mimir mimir
kubectl -n mimir delete secret basic-auth

#helm uninstall -n tempo tempo
#kubectl -n tempo delete secret basic-auth
