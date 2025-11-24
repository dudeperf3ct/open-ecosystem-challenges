#!/usr/bin/env bash
set -euo pipefail

# Load shared libraries
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../../../lib/loader.sh"

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
check_app_reachable "echo-server-staging" "echo-staging" 8081 80 "Staging" \
  "Hostname: echo-server-staging" \
  "Check if the ArgoCD ApplicationSet is configured correctly"

check_app_reachable "echo-server-prod" "echo-prod" 8082 80 "Production" \
  "Hostname: echo-server-prod" \
  "Check if the ArgoCD ApplicationSet is configured correctly"

# Define challenge objective and docs URL
OBJECTIVE="By the end of this level, you should:

- See two distinct Applications in the Argo CD dashboard (one per environment)
- Ensure each Application deploys to its own isolated namespace
- Make the system resilient so changes from outside Git cannot break it
- Confirm that updates happen automatically without leaving stale resources behind"

DOCS_URL="https://dynatrace-oss.github.io/open-ecosystem-challenges/01-echoes-lost-in-orbit/beginner"

SUCCESS_MESSAGE="It looks like you've successfully completed Level 1! 🌟"

NEXT_STEPS=(
  "Next steps:"
  "1. Commit your changes: git add . && git commit -m 'Solved Level 1'"
  "2. Push to main: git push origin main"
  "3. Manually trigger the 'Verify Adventure' workflow on GitHub Actions"
  "4. Once verified, share your success with the community! 🎉"
  ""
  "📖 For detailed verification instructions, see:"
  "   https://dynatrace-oss.github.io/open-ecosystem-challenges/verification/"
)

# Display summary and exit
print_summary \
  "$OBJECTIVE" \
  "$DOCS_URL" \
  "$SUCCESS_MESSAGE" \
  "${NEXT_STEPS[@]}"
