#!/usr/bin/env bash
set -euo pipefail

# Load shared libraries
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../../../lib/scripts/loader.sh"

OBJECTIVE="By the end of this level, you should:

- See two distinct Applications in the Argo CD dashboard (one per environment)
- Ensure each Application deploys to its own isolated namespace
- Make the system resilient so Argo CD automatically reverts manual changes made to the cluster
- Confirm that updates happen automatically without leaving stale resources behind"

DOCS_URL="https://dynatrace-oss.github.io/open-ecosystem-challenges/01-echoes-lost-in-orbit/beginner"

print_header \
  'Challenge 01: Echoes Lost in Orbit' \
  'Level 1: Broken Echoes' \
  'Smoke Test Verification'

check_prerequisites kubectl curl

print_sub_header "Running smoke tests..."

# Track test results across all checks
TESTS_PASSED=0
TESTS_FAILED=0

# Check if both environments are reachable
is_app_reachable "echo-server-staging" "echo-staging" "healthz" 8081 80 "Staging" \
  "Hostname: echo-server-staging" \
  "Check if the ArgoCD ApplicationSet is configured correctly"

print_new_line

is_app_reachable "echo-server-prod" "echo-prod" "healthz" 8082 80 "Production" \
  "Hostname: echo-server-prod" \
  "Check if the ArgoCD ApplicationSet is configured correctly"

print_test_summary "broken echoes" "$DOCS_URL" "$OBJECTIVE"
