# Kubernetes / Helm
## Default values (key bits)
```yaml
replicaCount: 2
image:
  repository: ghcr.io/<owner>/shay-final-project
  tag: latest
container:
  port: 5007
service:
  type: ClusterIP
  port: 80
ingress:
  enabled: true
  className: traefik
  hosts:
    - host: ""
      paths:
        - path: /
          pathType: Prefix
```
### Install / Upgrade
```
NS=app-dev
kubectl create ns $NS
helm upgrade --install final-project k8s/helm-final-project -n $NS
kubectl get deploy,svc,ingress,pods -n $NS
```
### Clean up
```
helm uninstall final-project -n $NS
kubectl delete ns $NS
```