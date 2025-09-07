#!/bin/bash

helm uninstall -n alloy k8s-monitoring --cascade foreground
helm uninstall -n monitoring grafana
helm uninstall -n loki loki
helm uninstall -n mimir mimir
#helm uninstall -n tempo tempo

kubectl delete ns alloy loki mimir monitoring tempo
