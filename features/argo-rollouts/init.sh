#!/usr/bin/env bash
set -e

echo "✨ Installing Argo Rollouts"
kubectl create namespace argo-rollouts
kubectl apply -n argo-rollouts -f https://github.com/argoproj/argo-rollouts/releases/download/v1.8.3/install.yaml

echo "✨ Waiting for Argo Rollouts controller to be ready"
kubectl rollout status deployment/argo-rollouts -n argo-rollouts --timeout=300s

echo "✨ Installing Argo Rollouts Kubectl plugin"
curl -LO https://github.com/argoproj/argo-rollouts/releases/download/v1.8.3/kubectl-argo-rollouts-linux-amd64
chmod +x ./kubectl-argo-rollouts-linux-amd64
sudo mv ./kubectl-argo-rollouts-linux-amd64 /usr/local/bin/kubectl-argo-rollouts

echo "✅ Argo Rollouts is ready"