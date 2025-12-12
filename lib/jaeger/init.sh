#!/usr/bin/env bash
set -e

# Use a minimal Jaeger setup instead of deploying it via the operator to keep the Codespace lightweight and focused.

echo "✨ Adding Jaeger Helm repo"
helm repo add jaegertracing https://jaegertracing.github.io/helm-charts
helm repo update

echo "✨ Creating jaeger namespace"
kubectl create namespace jaeger

echo "✨ Installing Jaeger via Helm"
helm install jaeger jaegertracing/jaeger \
  --version 4.1.5 \
  --namespace jaeger \
  --values lib/jaeger/values.yaml \
  --wait \
  --timeout 5m

echo "✨ Deploy service"
kubectl -n jaeger apply -f lib/jaeger/manifests/service.yaml

echo "✅ Jaeger is ready"