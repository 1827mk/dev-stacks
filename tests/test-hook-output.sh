#!/bin/bash
# Test hook output parsing

cd "$(dirname "$0")/.."
source ./tests/lib/assertions.sh

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "TEST: Hook Output Parsing"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Test 1: FIX_BUG intent from Thai
describe "Intent Detection (Thai)"
it "detects FIX_BUG from Thai keyword"
result=$(echo '{"user_prompt":"แก้ bug ใน login"}' | bash ./hooks/user-prompt-submit.sh 2>/dev/null || true)
assert_contains "$result" "FIX_BUG"

it "detects ADD_FEATURE from Thai keyword"
result=$(echo '{"user_prompt":"เพิ่มฟีเจอร์ใหม่"}' | bash ./hooks/user-prompt-submit.sh 2>/dev/null || true)
assert_contains "$result" "ADD_FEATURE"

# Test 2: Complexity scoring
describe "Complexity Scoring"
it "scores typo fix as low complexity"
result=$(echo '{"user_prompt":"แก้ typo"}' | bash ./hooks/user-prompt-submit.sh 2>/dev/null || true)
assert_contains "$result" "Complexity: 0.1"

# Test 3: Intelligence Layer
describe "Intelligence Layer"
it "includes intelligence analysis"
result=$(echo '{"user_prompt":"สร้าง login page"}' | bash ./hooks/user-prompt-submit.sh 2>/dev/null || true)
assert_contains "$result" "INTELLIGENCE"

it "recommends frontend-design for UI task"
result=$(echo '{"user_prompt":"สร้าง login page"}' | bash ./hooks/user-prompt-submit.sh 2>/dev/null || true)
assert_contains "$result" "frontend"

# Test 4: Orchestration instruction
describe "Orchestration Instruction"
it "includes orchestrator invocation"
result=$(echo '{"user_prompt":"test task"}' | bash ./hooks/user-prompt-submit.sh 2>/dev/null || true)
assert_contains "$result" "ORCHESTRATION"
assert_contains "$result" "dev-stacks:orchestrator"

print_summary
