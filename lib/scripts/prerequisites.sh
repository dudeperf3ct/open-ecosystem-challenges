#!/usr/bin/env bash

# prerequisites.sh - Shared library for checking prerequisites
# This library provides functions to validate required tools and cluster connectivity

# Check if required tools are available
# Usage: check_prerequisites kubectl curl [tool3] [tool4] ...
check_prerequisites() {
  print_info "Checking prerequisites..."

  local missing_tools=()

  # Check each tool passed as argument
  for tool in "$@"; do
    if ! command -v "$tool" &> /dev/null; then
      missing_tools+=("$tool")
    fi
  done

  if [[ ${#missing_tools[@]} -gt 0 ]]; then
    print_error "❌ Missing required tools: ${missing_tools[*]}"
    print_info "Please ensure all tools are installed before running this test."
    exit 1
  fi

  # If kubectl is one of the tools, check cluster connectivity
  for tool in "$@"; do
    if [[ "$tool" == "kubectl" ]]; then
      if ! kubectl cluster-info &> /dev/null; then
        print_error "❌ Cannot connect to Kubernetes cluster"
        print_info "Please ensure your Kubernetes cluster is running."
        exit 1
      fi
      break
    fi
  done

  print_success "✓ All prerequisites met"
  echo ""
}

