#!/bin/bash
# Test config validation

cd "$(dirname "$0")/.."
source ./tests/lib/assertions.sh

CONFIG_FILE="./config/defaults.json"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "TEST: Config Validation"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Test 1: Config file exists
describe "Config File"
it "config file exists"
assert_file_exists "$CONFIG_FILE"

it "config is valid JSON"
if jq . "$CONFIG_FILE" > /dev/null 2>&1; then
    echo -e "    \033[0;32m✓\033[0m valid JSON"
    ((tests_passed++))
else
    echo -e "    \033[0;31m✗ invalid JSON\033[0m"
    ((tests_failed++))
fi

# Test 2: Required keys
describe "Required Keys"
it "has orchestrator config"
assert_json_has_key "$CONFIG_FILE" ".orchestrator"

it "has workflows"
assert_json_has_key "$CONFIG_FILE" ".orchestrator.workflows"

it "has agents"
assert_json_has_key "$CONFIG_FILE" ".agents"

print_summary
