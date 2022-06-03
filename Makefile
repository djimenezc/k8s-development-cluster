CLUSTER_NAME ?= dev-cluster

#k8s
kind-cluster-create:
	kind create cluster --name $(CLUSTER_NAME) --config kind/kind-config.yml

kind-cluster-destroy:
	kind delete cluster --name $(CLUSTER_NAME)

kind-cluster-get-info:
	kubectl cluster-info --context kind-dev-cluster

-include ./Makefile.argocd
-include ./Makefile.ingress
-include ./Makefile.jenkins
-include ./Makefile.crossplane
-include ./Makefile.prometheus
-include ./Makefile.grafana
-include ./Makefile.qemu
