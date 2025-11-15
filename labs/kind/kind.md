# kind
[kind (Kubernetes IN Docker)](https://github.com/kubernetes-sigs/kind) is a tool for running local Kubernetes clusters using Docker container 'nodes'. kind was primarily designed for testing Kubernetes itself, but may be used for local development or CI.

## Enable Kubernetes in Docker Desktop
An easy way to use kind for your local Kubernetes cluster is Docker Desktop and the details are explained in the [instructions](../../README.md#Kubernetes).

## Enable Kubernetes with kind and podman
You can use kind with [podman](https://podman.io) a daemonless container engine on (native or virtual) Debian if you can't use WSL2 or you don't want complexity of integration between WSL2 and Docker Destkop.

To install podman, run apt package manage command:
```
sudo apt update
sudo apt install podman
```

If you don't have kind cli in your environment, you need to install. Follow the instructions from the [official installation guide](https://kind.sigs.k8s.io/docs/user/quick-start/#installation). Or, if you are familiar to [asdf](../../README.md#asdf) a multi-runtime tool manage, you can simply install it using asdf commands. The details about asdf is below.
```
asdf add plugin kind
asdf install kind latest
asdf set -u kind <version>
```

After kind installation, you can create a new kind cluster:
```
kind create cluster
```

Or customize your cluster with config file:
```
kind create cluster --config <config.yaml>
```

After setup, open your linux terminal and run the following commands to verify Kubernetes is running:
```
kubectl version --client
kubectl get nodes
```
You will see nodes, which means your cluster is up and running.

Delete cluster:
```
kind delete cluster --name <name>
```

# Troubleshooting
- [kind](https://kind.sigs.k8s.io/docs/user/known-issues/#troubleshooting-kind)

