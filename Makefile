
ARGO_DEMO_APP_NAME ?= guestbook
ARGO_DEMO_APPS= guestbook ksonnet-guestbook helm-guestbook jsonnet-guestbook jsonnet-guestbook-tla kustomize-guestbook ksane pre-post-sync sync-waves helm-dependency sock-shop plugins blue-green apps

#k8s

k8s-kind-create-cluster:
	kind create cluster --name savi

k8s-kind-destroy-cluster:
	kind delete cluster --name savi

-include ./Makefile.argocd
-include ./Makefile.ingress
-include ./Makefile.jenkins
-include ./Makefile.crossplane
-include ./Makefile.prometheus
-include ./Makefile.grafana
