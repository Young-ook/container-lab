# Litmus
[LitmusChaos (Litmus)](https://litmuschaos.io/) is an open source Chaos Engineering platform that enables teams to identify weaknesses and potential outages in infrastructures by inducing chaos tests in a controlled way. Developers can practice Chaos Engineering with Litmus as it is easy to use, based on modern Chaos Engineering principles and community collaborated via an experment hub. Litmus takes a cloud-native approach to create, manage and monitor chaos, and the platform itself runs as a set of microservices and uses Kubernetes custom resources (CRs) to define the chaos intent, as well as the steady state hypothesis.

- [Litmus GitHub](https://github.com/litmuschaos/litmus)
- [Litmus Documents](https://docs.litmuschaos.io)

## Quick Start
Prerequisites:
- Helm 3.0+
- Kubernetes 1.17+
- Persistent volume 20GB

> [!TIP]
> Run a local Kubernetes cluster using [kind](../kind/kind.md) if you need
> ```bash
> kind create cluster --image kindest/node:v1.32.2
> ```

For quickstart, run bootstrap script:
```sh
bash up.sh
```

After vault server and vault secrets operator install, you can access vault UI via port forwarding. Run kubectl commend following or use `k9s` to enable port forwarding, and open localhost:9091 in your browser:

```sh
kubectl -n litmus port-forward svc/litmus-service-frontend 9091
```

The initial admin password for login is `litmus`, and you will see password change request page after logged in. Follow the instructions to update you admin password and access the Litmus management console.

## Clean up
Before you uninstall litmus resrouces from your kubernetes, make sure the chaos experiments you've created are removed. Then, execute command to uninstall packages:
```sh
bash clean.sh
```

## Troubleshooting

# Additional Resources

