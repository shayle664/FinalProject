# FinalProject
Tiny Flask app with CI → GHCR → K8s via Helm; Argo CD keeps cluster in sync.

## Quick start
docker build -t app:test .
docker run -p 5007:5007 app:test
open http://localhost:5007

## Deploy
helm upgrade --install final-project k8s/helm-final-project -n app-dev

## More
- App: ./App/README.md
- Kubernetes/Helm: ./k8s/README.md
- Ops (CI/CD + Argo CD): ./ops/README.md
