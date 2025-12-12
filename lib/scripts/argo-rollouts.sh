#!/usr/bin/env bash

# argo-rollouts.sh - Shared library for Argo Rollouts checks
# This library provides functions to check Argo Rollouts status

# Check if a rollout exists
# Usage: rollout_exists "rollout-name" "namespace"
# Returns: 0 if exists, 1 if not
rollout_exists() {
  if ! kubectl -n "$2" get rollout "$1" &> /dev/null; then
    return 1
  fi
  return 0
}

# Check if a rollout is healthy (fully promoted and ready)
# Usage: check_rollout_status "rollout-name" "namespace" "expected-image-tag" "hint"
# Returns: 0 if healthy, 1 if not
check_rollout_status() {
  local rollout_name=$1
  local ns=$2
  local expected_tag=$3
  local hint=$4
  local all_checks_passed=true

  print_test_section "Verifying $rollout_name Rollout Status"

  # Check if rollout exists
  if ! rollout_exists "$rollout_name" "$ns"; then
    print_error_indent "Rollout '$rollout_name' not found in namespace '$ns'"
    print_hint "$hint"
    TESTS_FAILED=$((TESTS_FAILED + 1))
    all_checks_passed=false
  else
    print_info_indent "✓ Rollout '$rollout_name' exists"
    TESTS_PASSED=$((TESTS_PASSED + 1))
  fi

  # Only continue if rollout exists
  if rollout_exists "$rollout_name" "$ns"; then
    # Check if rollout is healthy (not degraded, not progressing stuck)
    local rollout_phase
    rollout_phase=$(kubectl get rollout "$rollout_name" -n "$ns" -o jsonpath='{.status.phase}' 2>/dev/null || echo "Unknown")

    if [[ "$rollout_phase" == "Healthy" ]]; then
      print_info_indent "✓ Rollout phase is Healthy"
      TESTS_PASSED=$((TESTS_PASSED + 1))
    elif [[ "$rollout_phase" == "Progressing" ]]; then
      print_error_indent "Rollout is still Progressing (not fully promoted)"
      print_hint "$hint"
      TESTS_FAILED=$((TESTS_FAILED + 1))
      all_checks_passed=false
    elif [[ "$rollout_phase" == "Degraded" ]]; then
      print_error_indent "Rollout is Degraded (canary analysis may have failed)"
      print_hint "$hint"
      TESTS_FAILED=$((TESTS_FAILED + 1))
      all_checks_passed=false
    else
      print_error_indent "Rollout phase is '$rollout_phase' (expected: Healthy)"
      print_hint "$hint"
      TESTS_FAILED=$((TESTS_FAILED + 1))
      all_checks_passed=false
    fi

    # Get the current stable image (what's actually running in stable pods)
    local stable_image
    stable_image=$(kubectl get rollout "$rollout_name" -n "$ns" -o jsonpath='{.status.stableRS}' 2>/dev/null)

    if [ -n "$stable_image" ]; then
      # Get the replicaset and its image
      local rs_image
      rs_image=$(kubectl get rs -n "$ns" -l rollouts-pod-template-hash="$stable_image" -o jsonpath='{.items[0].spec.template.spec.containers[0].image}' 2>/dev/null || echo "")

      if [[ "$rs_image" == *"$expected_tag"* ]]; then
        print_info_indent "✓ Stable pods are running version $expected_tag"
        TESTS_PASSED=$((TESTS_PASSED + 1))
      else
        print_error_indent "Stable pods are NOT running version $expected_tag (found: $rs_image)"
        print_hint "$hint"
        TESTS_FAILED=$((TESTS_FAILED + 1))
        all_checks_passed=false
      fi
    else
      # Fallback: check the spec image (less reliable but better than nothing)
      local spec_image
      spec_image=$(kubectl get rollout "$rollout_name" -n "$ns" -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null || echo "")

      if [[ "$spec_image" == *"$expected_tag"* ]]; then
        print_info_indent "✓ Rollout spec has version $expected_tag"
        TESTS_PASSED=$((TESTS_PASSED + 1))
      else
        print_error_indent "Rollout spec does not have version $expected_tag (found: $spec_image)"
        print_hint "$hint"
        TESTS_FAILED=$((TESTS_FAILED + 1))
        all_checks_passed=false
      fi
    fi
  fi

  # Only show success message if all checks passed
  if [ "$all_checks_passed" = true ]; then
    print_new_line
    print_success "✅ Rollout '$rollout_name' is healthy!"
  fi
}

