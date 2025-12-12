#!/usr/bin/env bash
set -e

# Use a minimal Prometheus setup instead of kube-prometheus-stack to keep the Codespace lightweight and focused.

echo "✨ Adding prometheus-community Helm repo"
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts 2>/dev/null || true
helm repo update

echo "✨ Creating prometheus namespace"
kubectl create namespace prometheus

echo "✨ Installing Prometheus via Helm"
helm install prometheus prometheus-community/prometheus \
  --namespace prometheus \
  --values lib/prometheus/values.yaml \
  --wait \
  --timeout 5m

echo "✅ Prometheus is ready"