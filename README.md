# deploy a local development k8s cluster with kind

[![CI](https://github.com/djimenezc/devops-automation/actions/workflows/CI.yml/badge.svg)](https://github.com/djimenezc/devops-automation/actions/workflows/CI.yml)
[![Dependency Review](https://github.com/djimenezc/devops-automation/actions/workflows/dependency-review.yml/badge.svg)](https://github.com/djimenezc/devops-automation/actions/workflows/dependency-review.yml)
[![Security Scan](https://github.com/djimenezc/devops-automation/actions/workflows/security-scan.yml/badge.svg)](https://github.com/djimenezc/devops-automation/actions/workflows/security-scan.yml)
[![release](https://github.com/djimenezc/devops-automation/actions/workflows/release.yml/badge.svg)](https://github.com/djimenezc/devops-automation/actions/workflows/release.yml)

- Deploy argocd
- Deploy ingress controller


#SSH

.ssh/config

```shell
host i-* mi-*
    User ec2-user
    ProxyCommand sh -c "aws ssm start-session --target %h --document-name AWS-StartSSHSession --parameters 'portNumber=%p'"
    IdentityFile ~/.ssh/david-key.pem
    IdentitiesOnly yes
```

## Prometheus

What is the best combination of tools for monitoring, logging, and alerting in Kubernetes?

#prometheus #grafana #loki #robusta

https://www.youtube.com/watch?v=XR_yWlOEGiA&t=99s
