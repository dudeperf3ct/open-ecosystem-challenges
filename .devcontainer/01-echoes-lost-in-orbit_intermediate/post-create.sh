#!/usr/bin/env bash
set -e

features/lib/init.sh
features/kubernetes/init.sh
features/argocd/init.sh --read-only
features/argo-rollouts/init.sh
features/prometheus/init.sh