#!/usr/bin/env bash
set -e

echo "✨ Installing Kind"
curl -sS https://webi.sh/kind@v0.30.0 | sh

echo "✨ Installing kubectl"
curl -LO "https://dl.k8s.io/release/v1.34.1/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

echo "✨ Installing kubens"
curl -sS https://webi.sh/kubens@v0.9.5 | bash

echo "✨ Installing k9s"
curl -sS https://webinstall.dev/k9s@0.50.16 | bash

echo "✨ Installing Helm"
curl -LO "https://get.helm.sh/helm-v4.0.1-linux-amd64.tar.gz"
tar -zxvf helm-v4.0.1-linux-amd64.tar.gz
chmod +x linux-amd64/helm
sudo mv linux-amd64/helm /usr/local/bin/helm
rm -rf linux-amd64 helm-v4.0.1-linux-amd64.tar.gz

echo "✨ Starting Kind cluster"
kind create cluster --config lib/kubernetes/config.yaml --wait 300s
kubectl cluster-info

echo "✅ Kubernetes cluster is ready"