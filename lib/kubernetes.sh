#!/usr/bin/env bash

# kubernetes.sh - Shared library for Kubernetes resource checks
# This library provides functions to check k8s resources and application health

# Array to track port-forward PIDs for cleanup
declare -a PF_PIDS=()

# Check if a namespace exists
# Usage: namespace_exists "namespace-name"
# Returns: 0 if exists, 1 if not
namespace_exists() {
  if ! kubectl get namespace "$1" &> /dev/null; then
    return 1
  fi
  return 0
}

# Check if a service exists
# Usage: service_exists "service_name" "namespace-name"
# Returns: 0 if exists, 1 if not
service_exists() {
  if ! kubectl -n "$2" get service "$1" &> /dev/null; then
    return 1
  fi
  return 0
}

# Setup port forward for a service
# Usage: setup_port_forward "service-name" "namespace" 8081 80
# Args: service_name, namespace, local_port, remote_port
# Returns: PID of port-forward process, or empty string on failure
setup_port_forward() {
  local svc_name=$1
  local ns=$2
  local local_port=$3
  local remote_port=$4
  local pf_pid=""

  print_step "Setting up port-forward on localhost:$local_port..."
  kubectl port-forward "svc/$svc_name" "$local_port:$remote_port" -n "$ns" >/dev/null 2>&1 &
  pf_pid=$!
  PF_PIDS+=("$pf_pid")

  if ! wait_for_port_forward "$local_port"; then
    print_error_indent "Port-forward failed to establish"
    kill "$pf_pid" 2>/dev/null || true
    return 1
  fi

  echo "$pf_pid"
  return 0
}

# Wait for port-forward to be ready
# Usage: wait_for_port_forward 8081 10
# Args: port, max_wait_seconds
# Returns: 0 if ready, 1 if timeout
wait_for_port_forward() {
  local port=$1
  local max_wait=${2:-10}
  local waited=0

  while ! lsof -i:"$port" &>/dev/null && [[ $waited -lt $max_wait ]]; do
    sleep 0.5
    waited=$((waited + 1))
  done

  if [[ $waited -ge $max_wait ]]; then
    return 1
  fi
  return 0
}

# Main function to check if an application is reachable
# Usage: is_app_reachable "service-name" "namespace" "endpoint" local_port remote_port "Label" "expected-string" "hint"
# Args: service_name, namespace, endpoint, local_port, remote_port, label, expected_response, hint
is_app_reachable() {
  # args
  local svc=$1
  local ns=$2
  local endpoint=$3
  local local_port=$4
  local remote_port=${5:-80}
  local label=$6
  local expected=$7
  local hint=$8

  local pf_pid=""
  local tmpfile=$(mktemp)
  local failed=0

  print_test_section "Checking $label Environment"

  # Check namespace exists
  if ! namespace_exists "$ns" "$hint"; then
    print_error_indent "Namespace '$ns' does not exist"
    print_hint "$hint"

    TESTS_FAILED=$((TESTS_FAILED + 1))
    return
  else
    print_info_indent "✓ Namespace '$ns' exists"
    TESTS_PASSED=$((TESTS_PASSED + 1))
  fi

  # Check service exists
  if ! service_exists "$svc" "$ns" "$hint"; then
    print_error_indent "Service "$svc" in '$ns' does not exist"
    print_hint "$hint"

    TESTS_FAILED=$((TESTS_FAILED + 1))
    return
  else
    print_info_indent "✓ Service "$svc" in '$ns' exists"
    TESTS_PASSED=$((TESTS_PASSED + 1))
  fi

  # Create port forward
  if ! pf_pid=$(setup_port_forward "$svc" "$ns" "$local_port" "$remote_port"); then
    return
  fi

  if ! test_http_endpoint "http://localhost:$local_port/$endpoint" "$expected" "$hint"; then
    return
  fi

  print_new_line
  print_success "✅ $label is healthy!"
}

# Cleanup function to ensure port-forwards are killed
cleanup_port_forwards() {
  local exit_code=$?
  if [[ ${#PF_PIDS[@]} -gt 0 ]]; then
    for pid in "${PF_PIDS[@]}"; do
      kill "$pid" 2>/dev/null || true
    done
  fi
  exit "$exit_code"
}