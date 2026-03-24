# Istio
[Istio](https://istio.io) is an open source service mesh that layers transparently onto existing distributed applications. Istio's powerful features provide a uniform way to integrate microservices, manage traffic flow across microservices, enforce policies and aggregate telemetry data. Istio's control plane provides an abstraction layer over the underlying cluster management platform, such as Kubernetes.

Istio is composed of these components:

- **Envoy** - Sidecar proxies per microservice to handle ingress/egress traffic between services in the cluster and from a service to external services. The proxies form a secure microservice mesh providing a rich set of functions like discovery, rich layer-7 routing, circuit breakers, policy enforcement and telemetry recording/reporting functions.
- **Ztunnel** - A lightweight data plane proxy written in Rust, used in Ambient mesh mode to provide secure connectivity and observability for workloads without sidecar proxies.
- **Istiod** - The Istio control plane. It provides service discovery, configuration and certificate management.

## Quick Start
The testing environment:
- Istio Helm Chart 1.29
- Helm 3.18.1
- Kubernetes 1.35.0
- (Optional) Istioctl 1.29
- 4GB+ RAM

> [!NOTE]
> If you enable telemetry / logging / tracing, Memory/CPU overhead will increase.

> [!CAUTION]
> There is an issue in automatic sidecar injection via Mutating Webhook Admission on Minikube

You can install Istio with one of the popular opstions - Helm, Istioctl
- [Install Istio with Helm](https://istio.io/latest/docs/setup/install/helm/)
- [Install Istio using Istioctl](https://istio.io/latest/docs/setup/getting-started/)

### Install with Helm
Run your Kubernetes cluster using [kind](../kind/kind.md), or your preferred provider. When your Kubernetes is ready, run the bootstrap script for quickstart. This script setup up prerequisites and install Istio using Helm, a popular package manager for Kubernetes distributed applications.

```sh
bash up.sh
```

If no issues, you will see proper pods in the istio-system namespace.
```sh
kubectl -n istio-system get po
NAME                    READY   STATUS    RESTARTS   AGE
istiod-868857f6-6h69v   1/1     Running   0          53s
```

## Clean up
Before you uninstall istio resrouces from your kubernetes, don't forget to remove the examples. If you installed Istio using Helm and bootstrap script, run the command to uninstall helm release and clean up resources.
```sh
bash clean.sh
```

## Troubleshooting

# Additional Resources
- [Istio GitHub](https://github.com/istio/istio)
