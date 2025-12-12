#!/usr/bin/env bash
set -e

echo "✨ Starting level 2 - Intermediate"

REPO_URL="https://github.com/${GITHUB_REPOSITORY}.git"
sed -i "s|__REPO_URL__|${REPO_URL}|g" adventures/01-echoes-lost-in-orbit/intermediate/manifests/appset.yaml

kubectl apply -n argocd -f adventures/01-echoes-lost-in-orbit/intermediate/manifests/appset.yaml

# Give ArgoCD some time to process the ApplicationSet and create the Rollout application
sleep 10

# Update podinfo image to trigger a rollout
sed -i 's|podinfo:6.8.0|podinfo:6.9.3|g' adventures/01-echoes-lost-in-orbit/intermediate/manifests/base/rollout.yaml
git add adventures/01-echoes-lost-in-orbit/intermediate/manifests/base/rollout.yaml
git commit -m "Update podinfo image to 6.9.3"
git push

# Refresh ArgoCD to pick up the new commit
argocd app get echo-server-staging --refresh
argocd app get echo-server-prod --refresh

lib/argo-rollouts/connect.sh