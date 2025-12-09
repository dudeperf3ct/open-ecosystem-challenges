#!/usr/bin/env bash
set -e

# Use a minimal Prometheus setup instead of kube-prometheus-stack to keep the Codespace lightweight and focused.

echo "✨ Installing kube-state-metrics (prerequisite)"
features/kube-state-metrics/init.sh

echo "✨ Adding prometheus-community Helm repo"
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts 2>/dev/null || true
helm repo update

echo "✨ Creating prometheus namespace"
kubectl create namespace prometheus

echo "✨ Installing Prometheus via Helm"
helm install prometheus prometheus-community/prometheus \
  --namespace prometheus \
  --set server.service.type=NodePort \
  --set server.service.nodePort=30102 \
  --set alertmanager.enabled=false \
  --set prometheus-node-exporter.enabled=false \
  --set prometheus-pushgateway.enabled=false \
  --set kube-state-metrics.enabled=false \
  --set server.extraScrapeConfigs="
- job_name: 'kube-state-metrics'
  static_configs:
    - targets: ['kube-state-metrics.kube-state-metrics.svc.cluster.local:8080']
" \
  --wait \
  --timeout 5m

echo "✅ Prometheus is ready"