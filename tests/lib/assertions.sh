#!/bin/bash
# Assertion functions for Dev-Stacks tests

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

tests_run=0
tests_passed=0
tests_failed=0

describe() { echo -e "\n📋 $1"; }
it() { echo -e "  $1"; ((tests_run++)); }

assert_equals() {
  if [[ "$1" == "$2" ]]; then
    echo -e "    ${GREEN}✓${NC} equals"
    ((tests_passed++))
  else
    echo -e "    ${RED}✗ expected '$2' but got '$1'${NC}"
    ((tests_failed++))
  fi
}

assert_contains() {
  if [[ "$1" == *"$2"* ]]; then
    echo -e "    ${GREEN}✓${NC} contains '$2'"
    ((tests_passed++))
  else
    echo -e "    ${RED}✗ does not contain '$2'${NC}"
    ((tests_failed++))
  fi
}

assert_file_exists() {
  if [[ -f "$1" ]]; then
    echo -e "    ${GREEN}✓${NC} file exists: $1"
    ((tests_passed++))
  else
    echo -e "    ${RED}✗ file missing: $1${NC}"
    ((tests_failed++))
  fi
}

assert_json_has_key() {
  if jq -e "$2" "$1" > /dev/null 2>&1; then
    echo -e "    ${GREEN}✓${NC} has key $2"
    ((tests_passed++))
  else
    echo -e "    ${RED}✗ missing key $2${NC}"
    ((tests_failed++))
  fi
}

print_summary() {
  echo -e "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "Tests: $tests_run | Passed: $tests_passed | Failed: $tests_failed"
  echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  [[ $tests_failed -eq 0 ]]
}
