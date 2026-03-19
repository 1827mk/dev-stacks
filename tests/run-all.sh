#!/bin/bash
# Master test runner

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR/.."

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "           DEV-STACKS TEST SUITE"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

total_passed=0
total_failed=0

for test_file in tests/test-*.sh; do
    if [[ -x "$test_file" ]]; then
        echo ""
        echo "Running: $test_file"
        echo "----------------------------------------"
        if bash "$test_file"; then
            ((total_passed++))
        else
            ((total_failed++))
        fi
    fi
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "                    SUMMARY"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Test files passed: $total_passed"
echo "Test files failed: $total_failed"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

[[ $total_failed -eq 0 ]] && echo "✅ All tests passed!" || echo "❌ Some tests failed"
