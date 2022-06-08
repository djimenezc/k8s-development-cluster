# deploy a local development k8s cluster with kind

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