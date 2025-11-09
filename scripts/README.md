# helmctl

`helmctl` is a tool script to run helm commands with plugins and utilties for distributed application lifecycle management.

## Usage
This a command to install a helm chart to your Kubernetes cluster:
```bash
./helmctl install -c release.yaml
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
