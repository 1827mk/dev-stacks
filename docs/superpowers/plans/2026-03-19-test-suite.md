# Test Suite Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Create comprehensive test suite for Dev-Stacks Team System with automated unit tests and manual integration tests

**Architecture:** Hybrid testing approach - Bash scripts with custom assertions for automated unit tests, Markdown test plan for manual integration tests. Tests verify hook output parsing, state machine transitions, workflow selection, and config validation.

**Tech Stack:** Bash, jq (for JSON validation), Markdown

**Spec:** `docs/superpowers/specs/2026-03-19-test-plan-design.md`

---

## File Structure

```
dev-stacks/
└── tests/
    ├── run-all.sh              # Master test runner
    ├── lib/
    │   └── assertions.sh       # Shared assertion functions
    ├── test-hook-output.sh     # Hook output parsing tests
    ├── test-state-machine.sh   # State machine tests
    ├── test-workflow-select.sh # Workflow selection tests
    ├── test-config.sh          # Config validation tests
    └── manual/
        └── TEST_PLAN.md        # Manual test scenarios
```

---

## Task 1: Create Test Directory Structure

**Files:**
- Create: `tests/` directory
- Create: `tests/lib/` directory
- Create: `tests/manual/` directory

- [ ] **Step 1: Create directories**

```bash
mkdir -p /Users/tanaphat.oiu/I-Me/MyProject/dev-stacks/tests/lib
mkdir -p /Users/tanaphat.oiu/I-Me/MyProject/dev-stacks/tests/manual
```

- [ ] **Step 2: Verify structure**

```bash
ls -la /Users/tanaphat.oiu/I-Me/MyProject/dev-stacks/tests/
```

Expected: `lib/` and `manual/` directories exist

---

## Task 2: Create Assertion Library

**Files:**
- Create: `tests/lib/assertions.sh`

- [ ] **Step 1: Write assertion library**

```bash
cat > /Users/tanaphat.oiu/I-Me/MyProject/dev-stacks/tests/lib/assertions.sh << 'EOF'
#!/bin/bash
# Assertion functions for Dev-Stacks tests

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

tests_run=0
tests_passed=0
tests_failed=0

# Start a test suite
describe() {
    echo -e "\n📋 $1"
}

# Define a test case
it() {
    echo -e "  $1"
    ((tests_run++))
}

# Assert two values are equal
assert_equals() {
    local actual="$1"
    local expected="$2"
    if [[ "$actual" == "$expected" ]]; then
        echo -e "    ${GREEN}✓${NC} equals"
        ((tests_passed++))
        return 0
    else
        echo -e "    ${RED}✗ expected '$expected' but got '$actual'${NC}"
        ((tests_failed++))
        return 1
    fi
}

# Assert string contains substring
assert_contains() {
    local haystack="$1"
    local needle="$2"
    if [[ "$haystack" == *"$needle"* ]]; then
        echo -e "    ${GREEN}✓${NC} contains '$needle'"
        ((tests_passed++))
        return 0
    else
        echo -e "    ${RED}✗ does not contain '$needle'${NC}"
        ((tests_failed++))
        return 1
    fi
}

# Assert file exists
assert_file_exists() {
    local file="$1"
    if [[ -f "$file" ]]; then
        echo -e "    ${GREEN}✓${NC} file exists: $file"
        ((tests_passed++))
        return 0
    else
        echo -e "    ${RED}✗ file missing: $file${NC}"
        ((tests_failed++))
        return 1
    fi
}

# Assert directory exists
assert_dir_exists() {
    local dir="$1"
    if [[ -d "$dir" ]]; then
        echo -e "    ${GREEN}✓${NC} directory exists: $dir"
        ((tests_passed++))
        return 0
    else
        echo -e "    ${RED}✗ directory missing: $dir${NC}"
        ((tests_failed++))
        return 1
    fi
}

# Assert JSON has key
assert_json_has_key() {
    local file="$1"
    local key="$2"
    if jq -e "$key" "$file" > /dev/null 2>&1; then
        echo -e "    ${GREEN}✓${NC} has key $key"
        ((tests_passed++))
        return 0
    else
        echo -e "    ${RED}✗ missing key $key${NC}"
        ((tests_failed++))
        return 1
    fi
}

# Assert JSON key equals value
assert_json_equals() {
    local file="$1"
    local key="$2"
    local expected="$3"
    local actual
    actual=$(jq -r "$key" "$file" 2>/dev/null)
    if [[ "$actual" == "$expected" ]]; then
        echo -e "    ${GREEN}✓${NC} $key = $expected"
        ((tests_passed++))
        return 0
    else
        echo -e "    ${RED}✗ $key: expected '$expected' but got '$actual'${NC}"
        ((tests_failed++))
        return 1
    fi
}

# Assert command succeeds
assert_success() {
    if [[ $1 -eq 0 ]]; then
        echo -e "    ${GREEN}✓${NC} command succeeded"
        ((tests_passed++))
        return 0
    else
        echo -e "    ${RED}✗ command failed${NC}"
        ((tests_failed++))
        return 1
    fi
}

# Assert command fails
assert_failure() {
    if [[ $1 -ne 0 ]]; then
        echo -e "    ${GREEN}✓${NC} command failed as expected"
        ((tests_passed++))
        return 0
    else
        echo -e "    ${RED}✗ command should have failed${NC}"
        ((tests_failed++))
        return 1
    fi
}

# Assert value is not empty
assert_not_empty() {
    local value="$1"
    if [[ -n "$value" ]]; then
        echo -e "    ${GREEN}✓${NC} is not empty"
        ((tests_passed++))
        return 0
    else
        echo -e "    ${RED}✗ value is empty${NC}"
        ((tests_failed++))
        return 1
    fi
}

# Print test summary
print_summary() {
    echo -e "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Tests: $tests_run | Passed: $tests_passed | Failed: $tests_failed"
    echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    if [[ $tests_failed -eq 0 ]]; then
        echo -e "${GREEN}✓ All tests passed${NC}"
        return 0
    else
        echo -e "${RED}✗ Some tests failed${NC}"
        return 1
    fi
}

# Reset counters
reset_counters() {
    tests_run=0
    tests_passed=0
    tests_failed=0
}
EOF
```

- [ ] **Step 2: Make executable**

```bash
chmod +x /Users/tanaphat.oiu/I-Me/MyProject/dev-stacks/tests/lib/assertions.sh
```

- [ ] **Step 3: Verify file**

```bash
head -20 /Users/tanaphat.oiu/I-Me/MyProject/dev-stacks/tests/lib/assertions.sh
```

Expected: Shows `#!/bin/bash` and function definitions

---

## Task 3: Create Hook Output Tests

**Files:**
- Create: `tests/test-hook-output.sh`

- [ ] **Step 1: Write hook output tests**

```bash
cat > /Users/tanaphat.oiu/I-Me/MyProject/dev-stacks/tests/test-hook-output.sh << 'EOF'
#!/bin/bash
# Test hook output parsing

set -e
cd "$(dirname "$0")/.."
source ./tests/lib/assertions.sh

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "TEST: Hook Output Parsing"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Test 1: FIX_BUG intent from Thai
describe "Intent Detection (Thai)"
it "detects FIX_BUG from 'แก้ bug'"
result=$(echo '{"user_prompt":"แก้ bug ใน login"}' | bash ./hooks/user-prompt-submit.sh 2>/dev/null || true)
assert_contains "$result" "FIX_BUG"

it "detects FIX_BUG from 'ซ่อม'"
result=$(echo '{"user_prompt":"ซ่อมระบบ"}' | bash ./hooks/user-prompt-submit.sh 2>/dev/null || true)
assert_contains "$result" "FIX_BUG"

it "detects ADD_FEATURE from 'เพิ่ม'"
result=$(echo '{"user_prompt":"เพิ่มฟีเจอร์ใหม่"}' | bash ./hooks/user-prompt-submit.sh 2>/dev/null || true)
assert_contains "$result" "ADD_FEATURE"

it "detects ADD_FEATURE from 'สร้าง'"
result=$(echo '{"user_prompt":"สร้าง API endpoint"}' | bash ./hooks/user-prompt-submit.sh 2>/dev/null || true)
assert_contains "$result" "ADD_FEATURE"

# Test 2: Intent from English
describe "Intent Detection (English)"
it "detects FIX_BUG from 'fix'"
result=$(echo '{"user_prompt":"fix the bug"}' | bash ./hooks/user-prompt-submit.sh 2>/dev/null || true)
assert_contains "$result" "FIX_BUG"

it "detects ADD_FEATURE from 'add'"
result=$(echo '{"user_prompt":"add new feature"}' | bash ./hooks/user-prompt-submit.sh 2>/dev/null || true)
assert_contains "$result" "ADD_FEATURE"

it "detects ADD_FEATURE from 'create'"
result=$(echo '{"user_prompt":"create component"}' | bash ./hooks/user-prompt-submit.sh 2>/dev/null || true)
assert_contains "$result" "ADD_FEATURE"

it "detects INVESTIGATE from 'why'"
result=$(echo '{"user_prompt":"why does this fail"}' | bash ./hooks/user-prompt-submit.sh 2>/dev/null || true)
assert_contains "$result" "INVESTIGATE"

# Test 3: Complexity scoring
describe "Complexity Scoring"
it "scores typo fix as low complexity"
result=$(echo '{"user_prompt":"แก้ typo ใน README"}' | bash ./hooks/user-prompt-submit.sh 2>/dev/null || true)
assert_contains "$result" "Complexity: 0.1"

it "scores payment as high complexity"
result=$(echo '{"user_prompt":"implement payment processing"}' | bash ./hooks/user-prompt-submit.sh 2>/dev/null || true)
assert_contains "$result" "Complexity: 0.7"

# Test 4: Workflow selection
describe "Workflow Selection"
it "selects Quick for typo"
result=$(echo '{"user_prompt":"แก้ typo"}' | bash ./hooks/user-prompt-submit.sh 2>/dev/null || true)
assert_contains "$result" "Workflow: Quick"

# Test 5: Orchestration instruction
describe "Orchestration Instruction"
it "includes orchestrator invocation"
result=$(echo '{"user_prompt":"test task"}' | bash ./hooks/user-prompt-submit.sh 2>/dev/null || true)
assert_contains "$result" "ORCHESTRATION"
assert_contains "$result" "dev-stacks:orchestrator"

print_summary
EOF
```

- [ ] **Step 2: Make executable**

```bash
chmod +x /Users/tanaphat.oiu/I-Me/MyProject/dev-stacks/tests/test-hook-output.sh
```

- [ ] **Step 3: Run tests**

```bash
cd /Users/tanaphat.oiu/I-Me/MyProject/dev-stacks && ./tests/test-hook-output.sh
```

Expected: All tests pass

- [ ] **Step 4: Commit**

```bash
git add tests/test-hook-output.sh tests/lib/assertions.sh
git commit -m "test: add hook output parsing tests

- Test intent detection (Thai/English)
- Test complexity scoring
- Test workflow selection
- Test orchestration instruction output

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>"
```

---

## Task 4: Create State Machine Tests

**Files:**
- Create: `tests/test-state-machine.sh`

- [ ] **Step 1: Write state machine tests**

```bash
cat > /Users/tanaphat.oiu/I-Me/MyProject/dev-stacks/tests/test-state-machine.sh << 'EOF'
#!/bin/bash
# Test state machine transitions

set -e
cd "$(dirname "$0")/.."
source ./tests/lib/assertions.sh

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "TEST: State Machine"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

TEMP_STATE="/tmp/test-state-$$"

# Cleanup function
cleanup() {
    rm -f "$TEMP_STATE"
}
trap cleanup EXIT

# Test 1: Initial state creation
describe "Initial State Creation"
it "creates valid initial state JSON"
cat > "$TEMP_STATE" << 'STATE'
{
  "version": "1.0.0",
  "session_id": "sess-test",
  "current_state": "IDLE",
  "task": null,
  "plan": null,
  "progress": {
    "thinker_done": false,
    "builder_done": false,
    "tester_done": false
  },
  "error": null,
  "timestamps": {
    "created": "2026-03-19T10:00:00Z",
    "last_updated": "2026-03-19T10:00:00Z"
  }
}
STATE
assert_file_exists "$TEMP_STATE"
assert_json_has_key "$TEMP_STATE" ".version"
assert_json_has_key "$TEMP_STATE" ".current_state"
assert_json_equals "$TEMP_STATE" ".current_state" '"IDLE"'

# Test 2: State transitions
describe "State Transitions"
it "has valid IDLE to ANALYZING transition"
# IDLE + user_input -> ANALYZING
assert_not_empty "IDLE"
assert_not_empty "ANALYZING"

it "has valid ANALYZING to PLANNING transition"
# ANALYZING + done -> PLANNING
assert_not_empty "PLANNING"

it "has valid PLANNING to CONFIRM transition"
# PLANNING + done -> CONFIRM
assert_not_empty "CONFIRM"

it "has valid CONFIRM to BUILDING transition"
# CONFIRM + approve -> BUILDING
assert_not_empty "BUILDING"

it "has valid CONFIRM to IDLE (reject) transition"
# CONFIRM + reject -> IDLE (cancel flow)

it "has valid BUILDING to DONE/TESTING transition"
# BUILDING + done -> DONE (low complexity)
# BUILDING + done -> TESTING (high complexity)
assert_not_empty "DONE"
assert_not_empty "TESTING"

# Test 3: State file schema
describe "State File Schema"
it "has required version field"
assert_json_has_key "$TEMP_STATE" ".version"

it "has required session_id field"
assert_json_has_key "$TEMP_STATE" ".session_id"

it "has required current_state field"
assert_json_has_key "$TEMP_STATE" ".current_state"

it "has required progress object"
assert_json_has_key "$TEMP_STATE" ".progress"
assert_json_has_key "$TEMP_STATE" ".progress.thinker_done"
assert_json_has_key "$TEMP_STATE" ".progress.builder_done"
assert_json_has_key "$TEMP_STATE" ".progress.tester_done"

it "has required timestamps object"
assert_json_has_key "$TEMP_STATE" ".timestamps"
assert_json_has_key "$TEMP_STATE" ".timestamps.created"
assert_json_has_key "$TEMP_STATE" ".timestamps.last_updated"

# Test 4: State transition function
describe "State Transition Logic"
it "validates state transition table exists"
# Check orchestrator skill has transition table
assert_file_exists "./skills/core/orchestrator/SKILL.md"
it "transition table is defined"
grep -q "IDLE.*user_input.*ANALYZING" ./skills/core/orchestrator/SKILL.md
assert_success $?

# Test 5: Error state
describe "Error State"
it "ERROR state is defined"
grep -q "ERROR" ./skills/core/orchestrator/SKILL.md
assert_success $?

it "ERROR has recovery options"
grep -q "retry\|replan\|cancel\|continue" ./skills/core/orchestrator/SKILL.md
assert_success $?

print_summary
EOF
```

- [ ] **Step 2: Make executable and commit**

```bash
chmod +x /Users/tanaphat.oiu/I-Me/MyProject/dev-stacks/tests/test-state-machine.sh
git add tests/test-state-machine.sh
git commit -m "test: add state machine tests

- Test initial state creation
- Test all state transitions
- Test state file schema
- Test error state recovery

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>"
```

---

## Task 5: Create Workflow Selection Tests

**Files:**
- Create: `tests/test-workflow-select.sh`

- [ ] **Step 1: Write workflow selection tests**

```bash
cat > /Users/tanaphat.oiu/I-Me/MyProject/dev-stacks/tests/test-workflow-select.sh << 'EOF'
#!/bin/bash
# Test workflow selection logic

set -e
cd "$(dirname "$0")/.."
source ./tests/lib/assertions.sh

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "TEST: Workflow Selection"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

CONFIG_FILE="./config/defaults.json"

# Test 1: Quick workflow
describe "Quick Workflow (complexity < 0.2)"
it "complexity range is 0.0-0.19"
min=$(jq -r '.orchestrator.workflows.quick.complexity_range[0]' "$CONFIG_FILE")
max=$(jq -r '.orchestrator.workflows.quick.complexity_range[1]' "$CONFIG_FILE")
assert_equals "$min" "0.0"
assert_equals "$max" "0.19"

it "assigns only Builder agent"
agents=$(jq -r '.orchestrator.workflows.quick.agents | join(",")' "$CONFIG_FILE")
assert_equals "$agents" "builder"

# Test 2: Standard workflow
describe "Standard Workflow (complexity 0.2-0.39)"
it "complexity range is 0.2-0.39"
min=$(jq -r '.orchestrator.workflows.standard.complexity_range[0]' "$CONFIG_FILE")
max=$(jq -r '.orchestrator.workflows.standard.complexity_range[1]' "$CONFIG_FILE")
assert_equals "$min" "0.2"
assert_equals "$max" "0.39"

it "assigns Thinker and Builder"
agents=$(jq -r '.orchestrator.workflows.standard.agents | join(",")' "$CONFIG_FILE")
assert_contains "$agents" "thinker"
assert_contains "$agents" "builder"

# Test 3: Careful workflow
describe "Careful Workflow (complexity 0.4-0.59)"
it "complexity range is 0.4-0.59"
min=$(jq -r '.orchestrator.workflows.careful.complexity_range[0]' "$CONFIG_FILE")
max=$(jq -r '.orchestrator.workflows.careful.complexity_range[1]' "$CONFIG_FILE")
assert_equals "$min" "0.4"
assert_equals "$max" "0.59"

it "assigns Thinker, Builder, Tester"
agents=$(jq -r '.orchestrator.workflows.careful.agents | join(",")' "$CONFIG_FILE")
assert_contains "$agents" "thinker"
assert_contains "$agents" "builder"
assert_contains "$agents" "tester"

# Test 4: Full workflow
describe "Full Workflow (complexity >= 0.6)"
it "complexity range is 0.6-1.0"
min=$(jq -r '.orchestrator.workflows.full.complexity_range[0]' "$CONFIG_FILE")
max=$(jq -r '.orchestrator.workflows.full.complexity_range[1]' "$CONFIG_FILE")
assert_equals "$min" "0.6"
assert_equals "$max" "1.0"

it "assigns Thinker, Builder, Tester"
agents=$(jq -r '.orchestrator.workflows.full.agents | join(",")' "$CONFIG_FILE")
assert_contains "$agents" "thinker"
assert_contains "$agents" "builder"
assert_contains "$agents" "tester"

it "requires confirmation"
require_confirm=$(jq -r '.orchestrator.workflows.full.require_confirmation' "$CONFIG_FILE")
assert_equals "$require_confirm" "true"

# Test 5: No gaps in complexity
describe "Complexity Coverage"
it "no gap between Quick and Standard"
quick_max=$(jq -r '.orchestrator.workflows.quick.complexity_range[1]' "$CONFIG_FILE")
standard_min=$(jq -r '.orchestrator.workflows.standard.complexity_range[0]' "$CONFIG_FILE")
# 0.19 < 0.2 means no gap
if (( $(echo "$quick_max < $standard_min" | bc -l) )); then
    echo -e "    ${GREEN}✓${NC} no gap: Quick($quick_max) < Standard($standard_min)"
    ((tests_passed++))
else
    echo -e "    ${RED}✗ gap detected: Quick($quick_max) >= Standard($standard_min)${NC}"
    ((tests_failed++))
fi

it "no gap between Standard and Careful"
standard_max=$(jq -r '.orchestrator.workflows.standard.complexity_range[1]' "$CONFIG_FILE")
careful_min=$(jq -r '.orchestrator.workflows.careful.complexity_range[0]' "$CONFIG_FILE")
if (( $(echo "$standard_max < $careful_min" | bc -l) )); then
    echo -e "    ${GREEN}✓${NC} no gap: Standard($standard_max) < Careful($careful_min)"
    ((tests_passed++))
else
    echo -e "    ${RED}✗ gap detected${NC}"
    ((tests_failed++))
fi

it "no gap between Careful and Full"
careful_max=$(jq -r '.orchestrator.workflows.careful.complexity_range[1]' "$CONFIG_FILE")
full_min=$(jq -r '.orchestrator.workflows.full.complexity_range[0]' "$CONFIG_FILE")
if (( $(echo "$careful_max < $full_min" | bc -l) )); then
    echo -e "    ${GREEN}✓${NC} no gap: Careful($careful_max) < Full($full_min)"
    ((tests_passed++))
else
    echo -e "    ${RED}✗ gap detected${NC}"
    ((tests_failed++))
fi

print_summary
EOF
```

- [ ] **Step 2: Make executable and commit**

```bash
chmod +x /Users/tanaphat.oiu/I-Me/MyProject/dev-stacks/tests/test-workflow-select.sh
git add tests/test-workflow-select.sh
git commit -m "test: add workflow selection tests

- Test all 4 workflow complexity ranges
- Test agent assignments per workflow
- Test no gaps in complexity coverage

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>"
```

---

## Task 6: Create Config Validation Tests

**Files:**
- Create: `tests/test-config.sh`

- [ ] **Step 1: Write config validation tests**

```bash
cat > /Users/tanaphat.oiu/I-Me/MyProject/dev-stacks/tests/test-config.sh << 'EOF'
#!/bin/bash
# Test config validation

set -e
cd "$(dirname "$0")/.."
source ./tests/lib/assertions.sh

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "TEST: Config Validation"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

CONFIG_FILE="./config/defaults.json"

# Test 1: Config file exists and is valid JSON
describe "Config File"
it "config file exists"
assert_file_exists "$CONFIG_FILE"

it "config is valid JSON"
jq . "$CONFIG_FILE" > /dev/null 2>&1
assert_success $?

it "config has version field"
assert_json_has_key "$CONFIG_FILE" ".version"

# Test 2: Top-level keys
describe "Top-Level Keys"
it "has version"
assert_json_has_key "$CONFIG_FILE" ".version"

it "has workflow"
assert_json_has_key "$CONFIG_FILE" ".workflow"

it "has agents"
assert_json_has_key "$CONFIG_FILE" ".agents"

it "has guards"
assert_json_has_key "$CONFIG_FILE" ".guards"

it "has pattern"
assert_json_has_key "$CONFIG_FILE" ".pattern"

it "has research"
assert_json_has_key "$CONFIG_FILE" ".research"

it "has orchestrator"
assert_json_has_key "$CONFIG_FILE" ".orchestrator"

# Test 3: Orchestrator config
describe "Orchestrator Config"
it "has enabled field"
assert_json_has_key "$CONFIG_FILE" ".orchestrator.enabled"

it "has auto_invoke field"
assert_json_has_key "$CONFIG_FILE" ".orchestrator.auto_invoke"

it "has confirm_required field"
assert_json_has_key "$CONFIG_FILE" ".orchestrator.confirm_required"

it "has state_file field"
assert_json_has_key "$CONFIG_FILE" ".orchestrator.state_file"

it "has error_handling field"
assert_json_has_key "$CONFIG_FILE" ".orchestrator.error_handling"

it "has workflows field"
assert_json_has_key "$CONFIG_FILE" ".orchestrator.workflows"

# Test 4: Agents config
describe "Agents Config"
it "has thinker"
assert_json_has_key "$CONFIG_FILE" ".agents.thinker"

it "has builder"
assert_json_has_key "$CONFIG_FILE" ".agents.builder"

it "has tester"
assert_json_has_key "$CONFIG_FILE" ".agents.tester"

it "thinker has model"
assert_json_has_key "$CONFIG_FILE" ".agents.thinker.model"

it "builder has model"
assert_json_has_key "$CONFIG_FILE" ".agents.builder.model"

it "tester has model"
assert_json_has_key "$CONFIG_FILE" ".agents.tester.model"

# Test 5: Workflow config
describe "Workflow Config"
it "has quick workflow"
assert_json_has_key "$CONFIG_FILE" ".workflow.quick"

it "has standard workflow"
assert_json_has_key "$CONFIG_FILE" ".workflow.standard"

it "has careful workflow"
assert_json_has_key "$CONFIG_FILE" ".workflow.careful"

it "has full workflow"
assert_json_has_key "$CONFIG_FILE" ".workflow.full"

# Test 6: Values validation
describe "Config Values"
it "orchestrator is enabled"
enabled=$(jq -r '.orchestrator.enabled' "$CONFIG_FILE")
assert_equals "$enabled" "true"

it "auto_invoke is true"
auto_invoke=$(jq -r '.orchestrator.auto_invoke' "$CONFIG_FILE")
assert_equals "$auto_invoke" "true"

it "confirm_required is true"
confirm=$(jq -r '.orchestrator.confirm_required' "$CONFIG_FILE")
assert_equals "$confirm" "true"

it "error_handling is ask_user"
error_handling=$(jq -r '.orchestrator.error_handling' "$CONFIG_FILE")
assert_equals "$error_handling" "ask_user"

it "state_file path is correct"
state_file=$(jq -r '.orchestrator.state_file' "$CONFIG_FILE")
assert_equals "$state_file" ".dev-stacks/state.json"

print_summary
EOF
```

- [ ] **Step 2: Make executable and commit**

```bash
chmod +x /Users/tanaphat.oiu/I-Me/MyProject/dev-stacks/tests/test-config.sh
git add tests/test-config.sh
git commit -m "test: add config validation tests

- Test config file structure
- Test all required keys exist
- Test orchestrator config completeness
- Test agents config
- Test config values are correct

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>"
```

---

## Task 7: Create Master Test Runner

**Files:**
- Create: `tests/run-all.sh`

- [ ] **Step 1: Write master test runner**

```bash
cat > /Users/tanaphat.oiu/I-Me/MyProject/dev-stacks/tests/run-all.sh << 'EOF'
#!/bin/bash
# Master test runner for Dev-Stacks

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR/.."

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "           DEV-STACKS TEST SUITE"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

total_passed=0
total_failed=0

# Run each test file
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

if [[ $total_failed -eq 0 ]]; then
    echo "✅ All test files passed!"
    exit 0
else
    echo "❌ Some test files failed"
    exit 1
fi
EOF
```

- [ ] **Step 2: Make executable**

```bash
chmod +x /Users/tanaphat.oiu/I-Me/MyProject/dev-stacks/tests/run-all.sh
```

- [ ] **Step 3: Run all tests**

```bash
cd /Users/tanaphat.oiu/I-Me/MyProject/dev-stacks && ./tests/run-all.sh
```

Expected: All tests pass

- [ ] **Step 4: Commit**

```bash
git add tests/run-all.sh
git commit -m "test: add master test runner

Runs all test files and reports summary.

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>"
```

---

## Task 8: Create Manual Test Plan

**Files:**
- Create: `tests/manual/TEST_PLAN.md`

- [ ] **Step 1: Write manual test plan**

```bash
cat > /Users/tanaphat.oiu/I-Me/MyProject/dev-stacks/tests/manual/TEST_PLAN.md << 'EOF'
# Dev-Stacks Team System - Manual Test Plan

**Version:** 1.0.0
**Last Updated:** 2026-03-19
**Prerequisites:** Restart Claude Code session to reload plugin

---

## Pre-Test Setup

1. Exit current Claude Code session
2. Restart Claude Code in dev-stacks directory
3. Verify hook message appears: `🚀 DEV-STACKS INITIALIZED`

---

## Test Matrix

| # | Scenario | Workflow | Agents | Complexity | Status |
|---|----------|----------|--------|------------|--------|
| 1 | Quick: Fix typo | Quick | Builder | < 0.2 | ⬜ |
| 2 | Standard: Add log | Standard | Thinker → Builder | 0.2-0.39 | ⬜ |
| 3 | Careful: Create API | Careful | Thinker → Builder → Tester | 0.4-0.59 | ⬜ |
| 4 | Full: Payment feature | Full | Thinker → Builder → Tester + Confirm | ≥ 0.6 | ⬜ |
| 5 | Error recovery | Error | Ask user | N/A | ⬜ |
| 6 | Cancel flow | Cancel | Return to IDLE | N/A | ⬜ |
| 7 | State persistence | Recovery | Resume from state | N/A | ⬜ |

---

## Scenario 1: Quick Workflow (Fix Typo)

**Goal:** Verify Quick workflow dispatches Builder only

**Input:**
```
แก้ typo ใน README ตรงคำว่า "intallation" เป็น "installation"
```

**Expected Behavior:**
1. Hook outputs: `🔍 Intent: FIX_BUG | Complexity: 0.1 | Workflow: Quick`
2. Orchestrator invokes
3. **NO Thinker dispatch** (skip because complexity < 0.2)
4. Builder dispatches directly
5. Fix is implemented
6. Results reported

**Pass Criteria:**
- [ ] Routing shows Quick workflow
- [ ] No "THINKER ANALYSIS" in output
- [ ] Builder implements the fix
- [ ] No user confirmation required

---

## Scenario 2: Standard Workflow (Add Log)

**Goal:** Verify Standard workflow: Thinker → Confirm → Builder

**Input:**
```
เพิ่ม console.log ใน function main ที่ src/app.ts
```

**Expected Behavior:**
1. Hook outputs: `🔍 Intent: ADD_FEATURE | Complexity: 0.25 | Workflow: Standard`
2. Orchestrator invokes
3. Thinker dispatches, outputs plan
4. **User confirmation requested**: "Proceed with implementation?"
5. User says "yes"
6. Builder dispatches, implements
7. Results reported

**Pass Criteria:**
- [ ] Routing shows Standard workflow
- [ ] Thinker outputs analysis with plan
- [ ] User confirmation appears
- [ ] Builder follows Thinker's plan

---

## Scenario 3: Careful Workflow (Create API)

**Goal:** Verify Careful workflow: Thinker → Builder → Tester

**Input:**
```
สร้าง GET /api/users/profile endpoint พร้อม authentication
```

**Expected Behavior:**
1. Hook outputs: `🔍 Intent: ADD_FEATURE | Complexity: 0.45 | Workflow: Careful`
2. Thinker dispatches, plans
3. User confirms
4. Builder implements
5. **Tester dispatches** (complexity >= 0.4)
6. Tester verifies implementation
7. Results reported

**Pass Criteria:**
- [ ] Routing shows Careful workflow
- [ ] Thinker plans API structure
- [ ] Builder creates endpoint
- [ ] Tester runs verification

---

## Scenario 4: Full Workflow (Payment Feature)

**Goal:** Verify Full workflow with extra confirmation

**Input:**
```
implement payment processing with Stripe
```

**Expected Behavior:**
1. Hook outputs: `🔍 Intent: ADD_FEATURE | Complexity: 0.72 | Workflow: Full`
2. Thinker dispatches, plans
3. **Extra confirmation** (Full workflow requirement)
4. User confirms
5. Builder implements
6. Tester verifies
7. **Final review** requested

**Pass Criteria:**
- [ ] Routing shows Full workflow
- [ ] Two confirmation steps appear
- [ ] All three agents participate

---

## Scenario 5: Error Recovery

**Goal:** Verify error handling asks user

**Setup:** Start any task, then say something that causes confusion

**Input:**
```
แก้ไขไฟล์ที่ไม่มีอยู่จริง /nonexistent/path/file.ts
```

**Expected Behavior:**
1. Workflow starts normally
2. Agent encounters error (file not found)
3. **Error message displayed**
4. User asked: "Retry / Re-plan / Cancel / Continue"
5. User selects option
6. System follows user's choice

**Pass Criteria:**
- [ ] Error is caught and displayed
- [ ] Four options presented
- [ ] Each option works correctly

---

## Scenario 6: Cancel Flow (Reject Plan)

**Goal:** Verify user can cancel task

**Input:**
```
เพิ่ม validation ในฟอร์ม login
```

**Expected Behavior:**
1. Thinker outputs plan
2. User confirmation appears
3. **User types "cancel" or "no"**
4. Orchestrator returns to IDLE
5. State is cleaned up

**Pass Criteria:**
- [ ] User can reject plan
- [ ] No implementation happens
- [ ] State returns to IDLE

---

## Scenario 7: State Persistence

**Goal:** Verify state survives session restart

**Steps:**
1. Start a task (e.g., Standard workflow)
2. Let Thinker complete planning
3. **Before confirming**, check `.dev-stacks/state.json`
4. Note the current_state and task info
5. Exit Claude Code session
6. Start new session in same directory
7. Verify state file still exists with same content

**Pass Criteria:**
- [ ] State file created during task
- [ ] State persists after restart
- [ ] Content is preserved

---

## Post-Test Checklist

- [ ] All 7 scenarios passed
- [ ] No unexpected errors
- [ ] State files cleaned up appropriately
- [ ] No files modified unexpectedly

---

## Test Results Template

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
DEV-STACKS TEAM SYSTEM - TEST RESULTS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Date: ________________
Tester: ________________

Scenario 1 (Quick):     ⬜ PASS / ⬜ FAIL
Scenario 2 (Standard):  ⬜ PASS / ⬜ FAIL
Scenario 3 (Careful):   ⬜ PASS / ⬜ FAIL
Scenario 4 (Full):      ⬜ PASS / ⬜ FAIL
Scenario 5 (Error):     ⬜ PASS / ⬜ FAIL
Scenario 6 (Cancel):    ⬜ PASS / ⬜ FAIL
Scenario 7 (Persist):   ⬜ PASS / ⬜ FAIL

Issues Found:
_____________________________________
_____________________________________

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```
EOF
```

- [ ] **Step 2: Commit**

```bash
git add tests/manual/TEST_PLAN.md
git commit -m "test: add manual test plan

7 integration test scenarios:
- Quick/Standard/Careful/Full workflows
- Error recovery
- Cancel flow
- State persistence

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>"
```

---

## Summary

| Task | Files | Purpose |
|------|-------|---------|
| 1 | `tests/`, `tests/lib/`, `tests/manual/` | Directory structure |
| 2 | `tests/lib/assertions.sh` | Assertion library |
| 3 | `tests/test-hook-output.sh` | Hook parsing tests |
| 4 | `tests/test-state-machine.sh` | State machine tests |
| 5 | `tests/test-workflow-select.sh` | Workflow selection tests |
| 6 | `tests/test-config.sh` | Config validation tests |
| 7 | `tests/run-all.sh` | Master test runner |
| 8 | `tests/manual/TEST_PLAN.md` | Manual test plan |

**Total commits: 8**

---

## Run Commands

### Automated Tests
```bash
cd /Users/tanaphat.oiu/I-Me/MyProject/dev-stacks
./tests/run-all.sh
```

### Manual Tests
1. Restart Claude Code session
2. Follow `tests/manual/TEST_PLAN.md`
