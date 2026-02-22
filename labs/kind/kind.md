# kind
[kind (Kubernetes IN Docker)](https://github.com/kubernetes-sigs/kind) is a tool for running local Kubernetes clusters using Docker container 'nodes'. kind was primarily designed for testing Kubernetes itself, but may be used for local development or CI.

## Enable Kubernetes in Docker Desktop
An easy way to use kind for your local Kubernetes cluster is Docker Desktop and the details are explained in the [instructions](../../README.md#Kubernetes).

## Enable Kubernetes with kind and Docker
You can install [docker](https://www.docker.com) directly in your Linux (Debian 12) environment if you don't want complexity of integration between WSL2 and Docker Destkop.

Install docker using `apt` package manager.
```sh
sudo apt update && sudo apt upgrade -y
sudo apt install -y docker.io
sudo systemctl enable --now docker
```

Ensure your user is part of the `docker` group to avoid permission issues.
```sh
sudo usermod -aG docker $USER
```

## Enable Kubernetes with kind and Podman
You can use kind with [podman](https://podman.io) a daemonless container engine on (native or virtual) Debian if you can't use WSL2 or you don't want complexity of integration between WSL2 and Docker Destkop.

To install podman, run `apt` package manage command.
```sh
sudo apt update && sudo apt upgrade -y
sudo apt install -y podman
```

To install kind cli, follow the instructions from the [official installation guide](https://kind.sigs.k8s.io/docs/user/quick-start/#installation). If you are familiar to [asdf](../../README.md#asdf) a multi-runtime tool manage, you can simply install it using asdf commands.
```sh
asdf add plugin kind
asdf install kind latest
asdf set -u kind <version>
```

After kind installation, you can create a new kind cluster.
```sh
kind create cluster
```

Or customize your cluster with config [file](./config/kind.yaml).
```sh
kind create cluster --config <config.yaml>
```

Verify your Kubernetes is running with kubectl command.
```sh
kubectl version --client
kubectl cluster-info
```

This is the kind command to delete your cluster. We recommend to delete useless clusters for cost efficiency.
```sh
kind delete cluster --name <name>
```

![kind](../../images/kind/kind.png)

## Troubleshooting
- [kind known issues](https://kind.sigs.k8s.io/docs/user/known-issues/#troubleshooting-kind)

# Alternatives

## minikube
[minikube](https://github.com/kubernetes/minikube) is local Kubernetes, focusing on making it easy to learn and develop for Kubernetes. With minikube, you can run local Kubernetes in a single command with Docker (or similarly compatible) container or a Virtual Machine environment.

This is the official [minikube quickstart guide](https://minikube.sigs.k8s.io/docs/start/), follow the instructions from installation minikube on your environment and deploy an example application.

If you are familiar to [asdf](../../README.md#asdf) a multi-runtime tool manage, you can simply install it using asdf commands.
```sh
asdf add plugin minikube
asdf install minikube latest
asdf set -u minikube <version>
```

Start your cluster.
```sh
minikube start
```

![minikube](../../images/kind/minikube.png)

