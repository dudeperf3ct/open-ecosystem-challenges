#!/usr/bin/env bash

# kubernetes.sh - Shared library for Kubernetes resource checks
# This library provides functions to check k8s resources and application health

# Check if a namespace exists
# Usage: namespace_exists "namespace-name"
# Returns: 0 if exists, 1 if not
namespace_exists() {
  if ! kubectl get namespace "$1" &> /dev/null; then
    return 1
  fi
  return 0
}

# Main function to check if an application is reachable
# Usage: check_app_reachable "service-name" "namespace" local_port remote_port "Label" "expected-string" "hint"
# Args: service_name, namespace, local_port, remote_port, label, expected_response, hint
check_app_reachable() {
  # args
  local svc=$1
  local ns=$2
  local local_port=$3
  local remote_port=${4:-80}
  local label=$5
  local expected=${6:-"Hostname: $svc_name"}
  local hint=$7

  local pf_pid=""
  local tmpfile=$(mktemp)
  local failed=0

  print_test_section "Checking $label Environment"

  # Check namespace exists
  if ! check_namespace "$ns" "$hint"; then
    print_error_indent "Namespace '$ns' does not exist"
    print_hint "$hint"

    TESTS_FAILED=$((TESTS_FAILED + 1))
    return 1
  else
    print_success_indent "Namespace '$ns' exists"
  fi

  return 0
}