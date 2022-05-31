
ARGO_DEMO_APP_NAME ?= guestbook
ARGO_DEMO_APPS= guestbook ksonnet-guestbook helm-guestbook jsonnet-guestbook jsonnet-guestbook-tla kustomize-guestbook ksane pre-post-sync sync-waves helm-dependency sock-shop plugins blue-green apps

#k8s

k8s-kind-create-cluster:
	kind create cluster --name savi

k8s-kind-destroy-cluster:
	kind delete cluster --name savi

#https://argo-cd.readthedocs.io/en/stable/getting_started/
k8s-argocd-install:
	kubectl create namespace argocd
	kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

k8s-argocd-delete:
	kubectl delete -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
	kubectl delete namespace argocd

k8s-argocd-make-public:
	kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

k8s-argocd-port-forwarding:
	kubectl port-forward svc/argocd-server -n argocd 8085:443

k8s-argocd-get-admin-password:
	kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo

# APPS https://github.com/argoproj/argocd-example-apps

k8s-argocd-apps-create-namespace:
	-kubectl create namespace argocd-apps

.PHONY: k8s-argocd-app-get

k8s-argocd-app-deploy: k8s-argocd-apps-create-namespace
	@echo deploying appName: $(ARGO_DEMO_APP_NAME)
	argocd app create $(ARGO_DEMO_APP_NAME) --repo https://github.com/djimenezc/argocd-example-apps.git --path $(ARGO_DEMO_APP_NAME) --dest-server https://kubernetes.default.svc --dest-namespace argocd-apps

k8s-argocd-app-get:
	@echo Getting appName: $(ARGO_DEMO_APP_NAME)
	argocd app get ${ARGO_DEMO_APP_NAME}

k8s-argocd-app-sync:
	@echo Syncing appName: $(ARGO_DEMO_APP_NAME)
	argocd app sync ${ARGO_DEMO_APP_NAME}

k8s-argocd-app-delete:
	@echo Deleting appName: $(ARGO_DEMO_APP_NAME)
	argocd app delete ${ARGO_DEMO_APP_NAME}

#$(ARGO_DEMO_APPS):
#	@echo hello app: $@
#
#$(OBJECTS):
#	@echo hello $@

#Ingress controller

k8s-ambassador-add-helm-repo:
	helm repo add datawire https://app.getambassador.io
	helm repo update

k8s-ambassador-install: k8s-ambassador-add-helm-repo
	kubectl create namespace ambassador
	kubectl apply -f https://app.getambassador.io/yaml/edge-stack/2.2.2/aes-crds.yaml
	kubectl wait --timeout=90s --for=condition=available deployment emissary-apiext -n emissary-system
	helm install edge-stack --namespace ambassador datawire/edge-stack && \
	kubectl -n ambassador wait --for condition=available --timeout=90s deploy -lproduct=aes

k8s-ambassador-delete:
	helm uninstall edge-stack --namespace ambassador
	kubectl delete -f https://app.getambassador.io/yaml/edge-stack/2.2.2/aes-crds.yaml
	kubectl delete namespace ambassador

#https://doc.traefik.io/traefik/getting-started/concepts/
#https://argo-cd.readthedocs.io/en/stable/operator-manual/ingress/#traefik-v22

k8s-traefik-add-helm-repo:
	helm repo add traefik https://helm.traefik.io/traefik
	helm repo update

k8s-traefik-install: k8s-traefik-add-helm-repo
	kubectl create namespace traefik
	helm install traefik --namespace traefik traefik/traefik

k8s-traefik-delete:
	helm uninstall traefik --namespace traefik
	kubectl delete namespace traefik

k8s-traefik-port-forwarding-dashboard:
	kubectl port-forward -n traefik $(shell kubectl get pods -n traefik --selector "app.kubernetes.io/name=traefik" --output=name) 9003:9000

k8s-traefik-route-dashboard:
	kubectl apply -f ingress/traefik-dashboard-route.yml -n traefik

#Crossplane

#Prometheus

#Grafana