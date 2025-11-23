# helmctl

`helmctl` is a tool script to run helm commands with plugins and utilties for distributed application lifecycle management.

## Install
To install copy the `helmctl` script into /usr/local/bin for all users, or add the path to the script to your *PATH* environment variable for a user (`.bashrc` or `.zshrc` or `.profile` file):
```bash
# set PATH so it includes helmctl bin
PATH="$HOME/container-lab/scripts:$PATH"
```

## Usage
This a command to install a helm chart to your Kubernetes cluster:
```bash
helmctl deploy -c release.yaml
```

And here is an example of release configuration `release.yaml`:
```yaml
---
release: loki
chart: grafana/loki
version: 6.31.0
namespace: loki
values:
- './config/loki.yaml'
```
