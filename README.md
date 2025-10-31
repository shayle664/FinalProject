# FinalProject — DevOps README
### Overview

A tiny Flask web app packaged in Docker, tested in GitHub Actions, published to GitHub Container Registry (GHCR), and deployed to Kubernetes (K3s) via a Helm chart. Optionally, Argo CD continuously watches the repo and auto-syncs changes to the cluster.

#### Key DevOps pieces

- CI for every push/PR (.github/workflows/ci-for-push.yml): fast style/type checks.
- Build & Release for main (.github/workflows/release-main.yml): build image, smoke-test, and push to GHCR (ghcr.io/<owner>/shay-final-project).
- Kubernetes: Helm chart in k8s/helm-final-project
  - 2 replicas
  - container port 5007, Service port 80
  - Ingress via Traefik (className: traefik)
- Argo CD (recommended): 1 Application that tracks the chart path and auto-deploys.
