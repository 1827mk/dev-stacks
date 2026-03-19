# Design Specification: Dev-Stacks Team System Test Plan

**Feature**: Test Suite for Team System
**Created**: 2026-03-19
**Status**: Draft
**Related**: `docs/superpowers/specs/2026-03-19-team-system-design.md`

---

## Overview

Test suite สำหรับ Dev-Stacks Team System ที่ประกอบด้วย:
- **Automated Tests**: Unit tests สำหรับ components ต่างๆ
- **Manual Tests**: Integration tests สำหรับ end-to-end scenarios

**Approach**: Hybrid (Automated + Manual)
**Framework**: Bash + assertions (no dependencies)

---

## Test Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                    TEST SUITE ARCHITECTURE                          │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                 AUTOMATED TESTS (Unit)                      │   │
│  │  Location: tests/                                           │   │
│  │  Framework: Bash + assertions                               │   │
│  │                                                             │   │
│  │  • test-hook-output.sh      - Hook parsing tests            │   │
│  │  • test-state-machine.sh    - State transition tests        │   │
│  │  • test-workflow-select.sh  - Workflow selection tests      │   │
│  │  • test-config.sh           - Config validation tests       │   │
│  │                                                             │   │
│  │  Run: ./tests/run-all.sh                                    │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                 MANUAL TESTS (Integration)                  │   │
│  │  Location: tests/manual/TEST_PLAN.md                       │   │
│  │                                                             │   │
│  │  Scenarios:                                                 │   │
│  │  1. Quick workflow (typo fix)                              │   │
│  │  2. Standard workflow (add log)                            │   │
│  │  3. Careful workflow (create API)                          │   │
│  │  4. Full workflow (payment feature)                        │   │
│  │  5. Error recovery                                         │   │
│  │  6. Cancel flow (reject plan)                              │   │
│  │  7. State persistence (restart session)                    │   │
│  │                                                             │   │
│  │  Run: Follow TEST_PLAN.md in new session                   │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## Directory Structure

```
dev-stacks/
└── tests/
    ├── run-all.sh              # Run all automated tests
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

## Automated Tests

### Assertion Library

**File:** `tests/lib/assertions.sh`

```bash
#!/bin/bash
# Assertion functions for tests

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
```

### Test 1: Hook Output Parsing

**File:** `tests/test-hook-output.sh`

| Test Case | Input | Expected Output |
|-----------|-------|-----------------|
| Thai FIX_BUG | "แก้ bug ใน login" | Intent: FIX_BUG |
| English ADD_FEATURE | "add new feature" | Intent: ADD_FEATURE |
| Low complexity (typo) | "แก้ typo" | Complexity: 0.1 |
| High complexity (payment) | "implement payment" | Complexity: 0.7 |
| Orchestration instruction | "test task" | Contains "dev-stacks:orchestrator" |

### Test 2: State Machine

**File:** `tests/test-state-machine.sh`

| Test Case | Description |
|-----------|-------------|
| Initial state | Creates valid IDLE state |
| Valid transitions | All 8 state transitions work |
| Invalid transitions | Blocked appropriately |

### Test 3: Workflow Selection

**File:** `tests/test-workflow-select.sh`

| Complexity | Expected Workflow | Expected Agents |
|------------|-------------------|-----------------|
| 0.1 | Quick | builder |
| 0.35 | Standard | thinker, builder |
| 0.5 | Careful | thinker, builder, tester |
| 0.8 | Full | thinker, builder, tester |

### Test 4: Config Validation

**File:** `tests/test-config.sh`

| Test Case | Description |
|-----------|-------------|
| Valid JSON | Config file parses correctly |
| Required keys | version, workflow, agents, guards, pattern, orchestrator |
| Orchestrator config | enabled, auto_invoke, workflows present |
| Complexity ranges | No gaps between workflow ranges |
| Agent definitions | thinker, builder, tester all defined |

---

## Manual Tests

### Test Matrix

| # | Scenario | Workflow | Agents | Complexity |
|---|----------|----------|--------|------------|
| 1 | Quick: Fix typo | Quick | Builder | < 0.2 |
| 2 | Standard: Add log | Standard | Thinker → Builder | 0.2-0.39 |
| 3 | Careful: Create API | Careful | Thinker → Builder → Tester | 0.4-0.59 |
| 4 | Full: Payment feature | Full | Thinker → Builder → Tester + Confirm | ≥ 0.6 |
| 5 | Error recovery | Error | Ask user | N/A |
| 6 | Cancel flow | Cancel | Return to IDLE | N/A |
| 7 | State persistence | Recovery | Resume from state | N/A |

### Scenario Details

#### Scenario 1: Quick Workflow
- **Input:** "แก้ typo ใน README"
- **Expected:** Hook → Orchestrator → Builder → Done
- **Verify:** No Thinker invoked, task completes

#### Scenario 2: Standard Workflow
- **Input:** "เพิ่ม console.log ใน function main"
- **Expected:** Hook → Orchestrator → Thinker → Confirm → Builder → Done
- **Verify:** Plan shown, confirmation requested

#### Scenario 3: Careful Workflow
- **Input:** "สร้าง GET /api/users/profile endpoint"
- **Expected:** Thinker → Confirm → Builder → Tester → Done
- **Verify:** Tester runs verification

#### Scenario 4: Full Workflow
- **Input:** "implement payment processing with Stripe"
- **Expected:** Thinker → Confirm → Builder → Tester → Done
- **Verify:** Extra confirmation required

#### Scenario 5: Error Recovery
- **Setup:** Start any task, simulate error
- **Expected:** Orchestrator shows error options
- **Options:** Retry / Replan / Cancel / Continue

#### Scenario 6: Cancel Flow
- **Input:** Start Standard workflow
- **Action:** Reject plan at confirmation
- **Expected:** Return to IDLE, cleanup performed

#### Scenario 7: State Persistence
- **Setup:** Start task, let Thinker complete
- **Action:** Exit session, restart
- **Expected:** State file persists, can resume

---

## Run Commands

### Run Automated Tests
```bash
cd /Users/tanaphat.oiu/I-Me/MyProject/dev-stacks
./tests/run-all.sh
```

### Run Manual Tests
1. Exit Claude Code session
2. Restart in dev-stacks directory
3. Follow `tests/manual/TEST_PLAN.md`

---

## Success Criteria

| Category | Criteria | Target |
|----------|----------|--------|
| Automated | All tests pass | 100% |
| Manual | All 7 scenarios pass | 7/7 |
| Coverage | All components tested | 100% |
| Regression | No breaking changes | 0 issues |

---

## Files to Create

| File | Purpose |
|------|---------|
| `tests/run-all.sh` | Master test runner |
| `tests/lib/assertions.sh` | Assertion library |
| `tests/test-hook-output.sh` | Hook parsing tests |
| `tests/test-state-machine.sh` | State machine tests |
| `tests/test-workflow-select.sh` | Workflow selection tests |
| `tests/test-config.sh` | Config validation tests |
| `tests/manual/TEST_PLAN.md` | Manual test plan |

**Total: 7 files**
