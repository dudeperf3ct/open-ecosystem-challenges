#!/usr/bin/env bash

# Print a styled header with multiple lines
# Usage: print_header "Line 1" "Line 2" "Line 3"
print_header() {
  gum style \
    --foreground 212 --border-foreground 212 --border double \
    --align center --width 60 --margin "1 0" --padding "1 2" \
    "$@"
}

# Print a styled subheader
# Usage: print_sub_header "Subheader text"
print_sub_header() {
  gum style --foreground 212 --bold "$@"
  echo ""
}

# Print success message
# Usage: print_success "Success message"
print_success() {
  gum style --foreground 120 "$@"
}

# Print error message
# Usage: print_error "Error message"
print_error() {
  gum style --foreground 196 "$@"
}

# Print info message
# Usage: print_info "Info message"
print_info() {
  gum style --foreground 246 "$@"
}

# Print warning message
# Usage: print_warning "Warning message"
print_warning() {
  gum style --foreground 214 "$@"
}

# Print indented success message
# Usage: print_success_indent "Message"
print_success_indent() {
  gum style --foreground 120 "  ✓ $*"
}

# Print indented error message
# Usage: print_error_indent "Message"
print_error_indent() {
  gum style --foreground 196 "  ❌ $*"
}

# Print indented info message
# Usage: print_info_indent "Message"
print_info_indent() {
  gum style --foreground 246 "  $*"
}

# Print indented hint message
# Usage: print_hint "Hint message"
print_hint() {
  gum style --foreground 246 "  💡 Hint: $*"
}

# Print test step message
# Usage: print_step "Step message"
print_step() {
  gum style --foreground 246 "  ⏳ $*"
}

# Print test section header
# Usage: print_test_section "Section name"
print_test_section() {
  gum style --bold "🔬 $*"
}

# Print a new line
# Usage: print_new_line
print_new_line() {
  echo ""
}

print_test_summary() {
  local level=$1
  local docs_url=$2
  local objective=$3

  print_header "Test Results Summary"

  if [[ $TESTS_FAILED -eq 0 ]]; then
    # test succeeded
    print_success "✅ PASSED: All $TESTS_PASSED checks passed"
    print_new_line
    print_info "It looks like you successfully completed this level! 🌟"

    print_info "Next steps:"
    print_info_indent "1. Commit your changes: git add . && git commit -m 'Solved Challenge'"
    print_info_indent "2. Push to main: git push origin main"
    print_info_indent "3. Manually trigger the 'Verify Adventure' workflow on GitHub Actions"
    print_info_indent "4. Once verified, share your success with the community! 🎉"
    print_new_line
    print_info "📖 For detailed verification instructions, see: https://dynatrace-oss.github.io/open-ecosystem-challenges/verification/"
    exit
  fi

  # test failed
  print_error "❌ FAILED: $TESTS_FAILED check(s) failed, $TESTS_PASSED passed"
  print_new_line
  gum style --bold "🎯 Challenge Objective:"
  print_info "$objective"
  print_new_line
  print_info "See $DOCS_URL for details"
}