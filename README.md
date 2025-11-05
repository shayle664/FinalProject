# FinalProject
Flask app with CI → GHCR → K8s via Helm; Argo CD keeps cluster in sync.

## Project Structure

```
FinalProject/
├── App/                      # Flask application source code
├── k8s/                      # Kubernetes and Helm configurations
│   ├── helm-final-project/   # Helm chart
│   └── k8s-simple.yaml       # Simple K8s manifest (alternative)
├── Dockerfile                # Container image definition
├── argo-app-dev.yaml         # Argo CD Application manifest
└── .github/workflows/        # CI/CD pipelines
```

## Prerequisites
Before starting, ensure you have the following installed:
- **Docker** (for local testing and building images)
- **Kubernetes cluster** (K3s, K8s, Minikube, or Docker Desktop with K8s enabled)
- **kubectl** (Kubernetes CLI)
- **Helm 3** (for deploying the application)
- **Git** (for cloning the repository)

## Getting Started

**Clone the repository:**
```bash
git clone https://github.com/shayle664/FinalProject.git
cd FinalProject
```

## Quick Start

### Option 1: Run Locally with Docker (for testing)
Build and run the app in a Docker container:
```bash
docker build -t app:test .
docker run -p 5007:5007 app:test
# Open http://localhost:5007 in your browser
```

### Option 2: Deploy to Kubernetes

Choose one of the following deployment methods:

#### A. Manual Deployment with Helm
Deploy the app directly to your Kubernetes cluster using Helm:
```bash
helm upgrade --install final-project k8s/helm-final-project -n app-dev --create-namespace
kubectl get deploy,svc,ingress,pods -n app-dev
```

#### B. GitOps Deployment with Argo CD (Recommended)
Argo CD automatically deploys and syncs your app from Git—no manual Helm commands needed.

**Step 1: Install Argo CD (one-time setup)**
```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

**Step 2: Deploy the Application**
```bash
kubectl apply -f argo-app-dev.yaml
```

**Step 3: Verify Deployment**
```bash
kubectl -n argocd get applications
kubectl -n app-dev get deploy,svc,ingress,pods
```

**Access the application:**

The Helm chart deploys with **Traefik Ingress enabled**. Choose one of these methods:

1. **Via Ingress** (if Traefik is installed in your cluster):
   - Get your ingress IP: `kubectl get ingress -n app-dev`
   - Visit: `http://<INGRESS-IP>/`
   - Example: `http://192.168.1.100/` or `http://localhost/` (for local clusters)

2. **Via Port-Forward** (works on any cluster, no ingress needed):
   ```bash
   kubectl port-forward -n app-dev svc/final-project 8080:80
   ```
   Then visit: `http://localhost:8080`

**Step 4: Test GitOps Auto-Sync**

Edit `k8s/helm-final-project/values.yaml` (change `replicaCount: 3` → `4`), commit and push to `main`. Argo CD will automatically detect the change and update your cluster:
```bash
kubectl -n argocd get application final-project -w
kubectl -n app-dev get deployment -w
```

---

## CI/CD Pipeline

### Continuous Integration (GitHub Actions)

**Workflow: `ci-for-push.yml`**

Runs on every push/PR (except direct pushes to `main`):
1. Checkout code
2. Setup Python 3.12
3. Install dependencies: `pip install -r App/requirements.txt && pip install ruff mypy`
4. Lint code: `ruff format --check .` and `ruff check .`
5. Type check: `mypy .`

**Workflow: `release-main.yml`**
- **On PR to `main`**: Build Docker image, start app on port 5007, run smoke tests with `curl` (`/`, `/hello/Shay`, `/hello/Noy`, `/shay` → 404)
- **On push to `main`**: Build, test, and push images to GitHub Container Registry:
  - `ghcr.io/shayle664/shay-final-project:latest`
  - `ghcr.io/shayle664/shay-final-project:<GITHUB_SHA>`

**Pull the latest image:**
```bash
docker pull ghcr.io/shayle664/shay-final-project:latest
```

### Continuous Deployment (GitOps)

Argo CD monitors the `main` branch and automatically deploys changes to the `app-dev` namespace when you push updates to:
- Helm chart templates
- `values.yaml` configuration
- Docker image tags

---

For more details:
- **Application**: See [App/README.md](./App/README.md)
- **Kubernetes/Helm**: See [k8s/README.md](./k8s/README.md)