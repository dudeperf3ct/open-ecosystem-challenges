#!/usr/bin/env bash
set -e

echo "✨ Adding prometheus-community Helm repo"
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

echo "✨ Creating kube-state-metrics namespace"
kubectl create namespace kube-state-metrics

echo "✨ Installing kube-state-metrics via Helm"
helm install kube-state-metrics prometheus-community/kube-state-metrics \
  --version 7.0.0 \
  --namespace kube-state-metrics \
  --values lib/kube-state-metrics/values.yaml \
  --wait \
  --timeout 5m

echo "✅ kube-state-metrics is ready"