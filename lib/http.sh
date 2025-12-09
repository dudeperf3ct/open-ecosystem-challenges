#!/usr/bin/env bash

# http.sh - Shared library for HTTP resource checks

# Test HTTP endpoint
# Usage: test_http_endpoint "http://localhost:8081/healthz" "expected-string" "hint"
test_http_endpoint() {
  local url=$1
  local expected=$2
  local hint=$3
  local response

  print_step "HTTP GET $url..."
  response=$(curl -s --max-time 5 "$url" 2>/dev/null || echo "")

  if [[ -z "$response" ]]; then
    print_error_indent "No response from app (connection failed)"
    print_hint "$hint"

    TESTS_FAILED=$((TESTS_FAILED + 1))
    return 1
  fi

  if [[ "$response" != *"$expected"* ]]; then
    print_error_indent "App responded but with unexpected content"
    print_info_indent "🔍 Expected to find: $expected"
    print_info_indent "📝 Actual response: $response"
    print_hint "$hint"

    TESTS_FAILED=$((TESTS_FAILED + 1))
    return 1
  fi

  print_info_indent "✓ App is reachable at $url and returned expected content"
  TESTS_PASSED=$((TESTS_PASSED + 1))
  return 0
}
