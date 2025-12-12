#!/usr/bin/env bash
set -euo pipefail

# Load shared libraries
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../../../lib/scripts/loader.sh"

OBJECTIVE="By the end of this level, you should have:
- Pod info version 6.9.3 deployed successfully in both staging and production environments
- Rollouts automatically progress through canary stages based on health metrics
- Two working PromQL queries in the AnalysisTemplate that validate application health during releases
- All rollouts complete successfully"

DOCS_URL="https://dynatrace-oss.github.io/open-ecosystem-challenges/01-echoes-lost-in-orbit/intermediate"

print_header \
  'Challenge 01: Echoes Lost in Orbit' \
  '🟡 Intermediate: The Silent Canary' \
  'Smoke Test Verification'

check_prerequisites kubectl curl

print_sub_header "Running smoke tests..."

# Track test results across all checks
TESTS_PASSED=0
TESTS_FAILED=0

# Check if both environments are reachable
is_app_reachable "echo-server" "echo-staging" "version" 8081 80 "Staging" \
  "\"version\": \"6.9.3\"" \
  "Check the Argo Rollouts UI for details on the staging rollout (select the 'echo-staging' namespace in the top right)"

print_new_line

is_app_reachable "echo-server" "echo-prod" "version" 8082 80 "Production" \
  "\"version\": \"6.9.3\"" \
  "Check the Argo Rollouts UI for details on the prod rollout (select the 'echo-prod' namespace in the top right)"

print_test_summary "silent canary" "$DOCS_URL" "$OBJECTIVE"