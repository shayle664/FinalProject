# FinalProject
Tiny Flask app with CI → GHCR → K8s via Helm; Argo CD keeps cluster in sync.

## Quick start
```
docker build -t app:test .
docker run -p 5007:5007 app:test
open http://localhost:5007
```
## Deploy
```
helm upgrade --install final-project k8s/helm-final-project -n app-dev
```
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
### Argo CD (run it)

#### 1) Install Argo CD (once)
kubectl create ns argocd
kubectl apply -n argocd \
  -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

#### 2) Apply the Application (tracks the Helm chart in this repo)
kubectl apply -f argo-app-dev.yaml          # metadata.namespace should be argocd

#### 3) Verify
kubectl -n argocd get applications
kubectl -n app-dev get deploy,svc,ingress,pods

#### 4) Prove GitOps: change replicas and push to main
####   edit: k8s/helm-final-project/values.yaml  (replicaCount: 2 -> 3)
kubectl -n argocd get application final-project -w
kubectl -n app-dev get deploy

## More
- App: ./App/README.md
- Kubernetes/Helm: ./k8s/README.md