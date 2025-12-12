#!/usr/bin/env bash
set -e

help() {
  echo "Usage: $0 [OPTIONS]"
  echo "Options:"
  echo " --help         Display this help message"
  echo " --read-only    Disables the ArgoCD admin user and only provides read-only access"
}

# Parse flags
read_only=false

for arg in "$@"; do
  case "$arg" in
    --help)
      help
      exit 0
      ;;
    --read-only)
      read_only=true
      ;;
    *)
      echo "Unknown option: $arg" >&2
      exit 1
      ;;
  esac
done

echo "✨ Installing Argo CD"
kubectl create namespace argocd
kubectl apply -k lib/argocd/manifests

echo "✨ Installing Argo CD CLI"
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/download/v3.2.0/argocd-linux-amd64
sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm argocd-linux-amd64

echo "✨ Waiting for Argo CD server to be ready"
kubectl rollout status deployment/argocd-server -n argocd --timeout=300s
sleep 3 # Give Argo CD a moment to be ready after restart


if [ "$read_only" = true ]; then
  echo "✨ Setting password for user readonly"
  admin_password=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
  argocd login localhost:30100 --username admin --password "$admin_password" --plaintext
  argocd account update-password \
    --account readonly \
    --current-password $admin_password \
    --new-password a-super-secure-password

  echo "✨ Disabling admin user for read-only mode"
  kubectl -n argocd patch configmap argocd-cm --type merge -p '{"data":{"accounts.admin.enabled":"false"}}'
  kubectl -n argocd delete secret argocd-initial-admin-secret

  echo "✨ Restarting Argo CD server"
  kubectl -n argocd rollout restart deployment/argocd-server
  kubectl rollout status deployment/argocd-server -n argocd --timeout=300s
  sleep 3 # Give Argo CD a moment to be ready after restart

  echo "✨ Logging in as readonly user"
  argocd login localhost:30100 --username readonly --password a-super-secure-password --plaintext
fi

echo "✅ Argo CD is ready"
