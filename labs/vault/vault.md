# HashiCorp Vault
[HashiCorp Vault](https://www.hashicorp.com/vault) is a tool for securely accessing secrets. A secret is anything that you want to tightly control access to, such as API keys, passwords, certificates, and more. Vault provides a unified interface to any secret, while providing tight access control and recording a detailed audit log.

- [HashiCorp Vault GitHub](https://github.com/hashicorp/vault)
- [Developer Guide: HashiCorp Vault](https://developer.hashicorp.com/vault)


## Quick Start
The versions required are:

- Helm 3.6+
- Kubernetes 1.29+

> [!TIP]
> Run a local Kubernetes cluster using [kind](../kind/kind.md) if you need
> ```bash
> kind create cluster --image kindest/node:v1.32.2
> ```

For quickstart, run bootstrap script:
```bash
bash up.sh
```

Clean up:
```bash
bash clean.sh
```


## Troubleshooting
```
server:
  extraEnvVars:
    # Disable FCAP
    - name: SKIP_SETCAP
      value: "true"
```

