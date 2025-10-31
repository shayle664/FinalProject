# FinalProject
Tiny Flask app with CI → GHCR → K8s via Helm; Argo CD keeps cluster in sync.

## Quick start
```
docker build -t app:test .
docker run -p 5007:5007 app:test
open http://localhost:5007
```
## Deploy
helm upgrade --install final-project k8s/helm-final-project -n app-dev

## Ops (CI/CD & GitOps)

**CI (GitHub Actions)**
- **ci-for-push.yml** — runs on every push/PR (except direct pushes to `main`):
  1. Checkout  
  2. Setup Python 3.12  
  3. `pip install -r App/requirements.txt && pip install ruff mypy`  
  4. `ruff format --check . && ruff check .`  
  5. `mypy .`
- **release-main.yml**
  - **PR → main**: build Docker image, run the app on port **5007**, smoke test with `curl` (`/`, `/hello/Shay`, `/hello/Noy`, and `/shay` = 404).
  - **Push → main**: build + smoke, then push to GHCR:
    - `ghcr.io/<OWNER>/shay-final-project:<GITHUB_SHA>`
    - `ghcr.io/<OWNER>/shay-final-project:latest`

**Image (pull example)**
```bash
docker pull ghcr.io/<OWNER>/shay-final-project:latest
```
## Kubernetes (Helm)
- Chart: k8s/helm-final-project
- Defaults: replicaCount=2, Service 80 → containerPort 5007, Ingress via Traefik.
```
NS=app-dev
helm upgrade --install final-project k8s/helm-final-project -n $NS
kubectl get deploy,svc,ingress,pods -n $NS
```
## Argo CD (GitOps) – Run It
**Goal:** auto-deploy the Helm chart in k8s/helm-final-project whenever you push to main.
#### Prereqs

- Kubernetes reachable (you’re on K3s)
- kubectl installed and pointing to the cluster

### 1) Install Argo CD (once)
```
kubectl create namespace argocd
kubectl apply -n argocd \
  -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```
#### Argo UI (pick one):
- Port-forward (quick):
kubectl -n argocd port-forward svc/argocd-server 8081:80 → open http://localhost:8081

### Apply it:
```
kubectl apply -f argo-app-dev.yaml
kubectl -n argocd get applications
```

## More
- App: ./App/README.md
- Kubernetes/Helm: ./k8s/README.md
- Ops (CI/CD + Argo CD): ./ops/README.md