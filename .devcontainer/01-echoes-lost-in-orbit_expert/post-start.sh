#!/usr/bin/env bash
set -e

echo "✨ Starting level 3 - Expert"

REPO_URL="https://github.com/${GITHUB_REPOSITORY}.git"
sed -i "s|__REPO_URL__|${REPO_URL}|g" adventures/01-echoes-lost-in-orbit/expert/manifests/appset.yaml

kubectl apply -n argocd -f adventures/01-echoes-lost-in-orbit/expert/manifests/appset.yaml

# Give ArgoCD some time to process the ApplicationSet and create the Rollout application
sleep 10

# Update hotrod image to trigger a rollout
sed -i 's|example-hotrod:1.75.0|example-hotrod:1.76.0|g' adventures/01-echoes-lost-in-orbit/expert/manifests/hotrod/rollout.yaml
git add adventures/01-echoes-lost-in-orbit/expert/manifests/hotrod/rollout.yaml
git commit -m "Update hotrod image to 1.76.0"
git push

# Refresh ArgoCD to pick up the new commit
argocd app get hotrod --refresh

lib/argo-rollouts/connect.sh