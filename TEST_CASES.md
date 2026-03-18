# Dev-Stacks Mock Test Cases

> Test scenarios for validating plugin functionality

---

## 1. Intent Router Tests

### Test Case 1.1: Thai Input - Fix Bug
**Input**: "แก้ typo ใน README ตรงคำว่า 'intallation'"
**Expected Intent**:
```json
{
  "category": "FIX_BUG",
  "target": "README.md",
  "language": "TH",
  "confidence": "> 0.9"
}
```
**Expected Workflow**: Quick (complexity < 0.2)

### Test Case 1.2: English Input - Add Feature
**Input**: "Add email validation to the login form"
**Expected Intent**:
```json
{
  "category": "ADD_FEATURE",
  "target": "login form validation",
  "language": "EN",
  "confidence": "> 0.85"
}
```
**Expected Workflow**: Standard (complexity 0.2-0.39)

### Test Case 1.3: Mixed Input - Investigate
**Input**: "ทำไม API /users ช้า?"
**Expected Intent**:
```json
{
  "category": "INVESTIGATE",
  "target": "API /users performance",
  "language": "MIXED",
  "confidence": "> 0.8"
}
```
**Expected Workflow**: Standard or Careful

### Test Case 1.4: Ambiguous Input
**Input**: "แก้ไข"
**Expected Behavior**: Ask for clarification
**Expected Output**: "🤔 Intent unclear. Please clarify..."

---

## 2. Complexity Scorer Tests

### Test Case 2.1: Simple Fix
**Input**: "แก้ typo ใน README"
**Expected Score**: 0.05 - 0.15
**Expected Workflow**: Quick
**Expected Team**: [Builder]

### Test Case 2.2: Moderate Feature
**Input**: "เพิ่ม email validation ในฟอร์ม login"
**Expected Score**: 0.25 - 0.35
**Expected Workflow**: Standard
**Expected Team**: [Thinker, Builder]

### Test Case 2.3: Complex Security Change
**Input**: "แก้ auth flow ให้ใช้ JWT refresh token"
**Expected Score**: 0.45 - 0.55
**Expected Workflow**: Careful
**Expected Team**: [Thinker, Builder, Tester]

### Test Case 2.4: Critical Payment System
**Input**: "implement Stripe payment integration"
**Expected Score**: 0.7 - 0.9
**Expected Workflow**: Full
**Expected Team**: [Thinker, Builder, Tester] + User Confirmation

---

## 3. Guard Tests

### Test Case 3.1: Scope Guard - Protected File
**Action**: Try to edit `.env` file
**Expected**: BLOCKED
**Expected Output**: "🛡️ Guard: BLOCKED - Protected file"

### Test Case 3.2: Scope Guard - Protected Path
**Action**: Try to edit `credentials.json`
**Expected**: BLOCKED
**Expected Output**: "🛡️ Guard: BLOCKED - Protected path"

### Test Case 3.3: Secret Scanner - API Key
**Action**: Try to write `const API_KEY = "sk-1234567890abcdef"`
**Expected**: BLOCKED
**Expected Output**: "🛡️ Secret Scanner: BLOCKED - API key detected"

### Test Case 3.4: Bash Guard - Dangerous Command
**Action**: Try to run `rm -rf /`
**Expected**: BLOCKED
**Expected Output**: "🛡️ Bash Guard: BLOCKED - Dangerous command"

### Test Case 3.5: Bash Guard - SQL Injection
**Action**: Try to run SQL with `DROP DATABASE`
**Expected**: BLOCKED
**Expected Output**: "🛡️ Bash Guard: BLOCKED - Dangerous command"

---

## 4. Workflow Tests

### Test Case 4.1: Quick Workflow
**Trigger**: Complexity score < 0.2
**Expected Behavior**:
1. No planning phase
2. Builder executes immediately
3. No confirmation required
4. Single agent: Builder

### Test Case 4.2: Standard Workflow
**Trigger**: Complexity score 0.2-0.39
**Expected Behavior**:
1. Thinker analyzes and plans
2. Builder implements
3. No confirmation required
4. Two agents: Thinker + Builder

### Test Case 4.3: Careful Workflow
**Trigger**: Complexity score 0.4-0.59
**Expected Behavior**:
1. Thinker analyzes and plans
2. Builder implements
3. Tester verifies
4. No confirmation required
5. Full team: Thinker + Builder + Tester

### Test Case 4.4: Full Workflow
**Trigger**: Complexity score >= 0.6
**Expected Behavior**:
1. Thinker analyzes and plans
2. User confirmation required before proceeding
3. Builder implements
4. Tester verifies
5. User confirmation at completion
6. Full team: Thinker + Builder + Tester

---

## 5. Pattern Memory Tests

### Test Case 5.1: Pattern Save
**Scenario**: Complete a task successfully
**Expected**: Prompt to save pattern
**Expected Output**: "📚 Found successful pattern. Save to memory?"

### Test Case 5.2: Pattern Suggestion
**Scenario**: User asks for similar task to saved pattern
**Expected**: Suggest relevant pattern
**Expected Output**: "📚 Found relevant pattern: [pattern-name] (confidence: 0.xx)"

### Test Case 5.3: Pattern Confidence Decay
**Scenario**: Pattern not used for 30+ days
**Expected**: Confidence decreases
**Expected Behavior**: Low confidence patterns suggested less frequently

---

## 6. Command Tests

### Test Case 6.1: /dev-stacks:status
**Command**: `/dev-stacks:status`
**Expected Output**:
- Project name and type
- Session stats
- Agent availability
- DNA summary

### Test Case 6.2: /dev-stacks:status --dna
**Command**: `/dev-stacks:status --dna`
**Expected Output**:
- Full DNA details
- Architecture breakdown
- All patterns

### Test Case 6.3: /dev-stacks:undo
**Command**: `/dev-stacks:undo`
**Expected Output**:
- Preview of changes to revert
- Confirmation prompt
- Undo levels available

### Test Case 6.4: /dev-stacks:learn
**Command**: `/dev-stacks:learn`
**Expected Output**:
- Pattern management options
- List, show, save, delete options

### Test Case 6.5: /dev-stacks:doctor
**Command**: `/dev-stacks:doctor`
**Expected Output**:
- System health check
- MCP server status
- DNA validity
- Fix recommendations

### Test Case 6.6: /dev-stacks:help
**Command**: `/dev-stacks:help`
**Expected Output**:
- Available commands
- Usage examples
- Quick reference

---

## 7. Hook Tests

### Test Case 7.1: SessionStart Hook
**Trigger**: New session starts
**Expected Behavior**:
1. Check for `.dev-stacks/` directory
2. Load DNA from `.dev-stacks/dna.json`
3. Load patterns from MCP Memory
4. Display welcome message

### Test Case 7.2: UserPromptSubmit Hook
**Trigger**: User submits any message
**Expected Behavior**:
1. Route to intent-router skill
2. Detect intent and complexity
3. Select appropriate workflow

### Test Case 7.3: PreToolUse Hook
**Trigger**: Before any tool use
**Expected Behavior**:
1. Check scope-guard
2. Check secret-scanner (for Write/Edit)
3. Check bash-guard (for Bash)

### Test Case 7.4: PostToolUse Hook
**Trigger**: After any tool use
**Expected Behavior**:
1. Log action to audit.jsonl
2. Update checkpoint

### Test Case 7.5: Stop Hook
**Trigger**: Session ends
**Expected Behavior**:
1. Save checkpoint
2. Display session summary

---

## 8. Agent Tests

### Test Case 8.1: Thinker Agent
**Trigger**: STANDARD, CAREFUL, or FULL workflow
**Expected Behavior**:
1. Analyze task requirements
2. Identify files to modify
3. Design implementation approach
4. Output structured plan

### Test Case 8.2: Builder Agent
**Trigger**: Always (all workflows)
**Expected Behavior**:
1. Implement based on plan (if provided)
2. Modify/create files
3. Handle errors gracefully
4. Report completion

### Test Case 8.3: Tester Agent
**Trigger**: CAREFUL or FULL workflow
**Expected Behavior**:
1. Verify implementation
2. Run tests if available
3. Check for regressions
4. Report verification results

---

## 9. Edge Case Tests

### Test Case 9.1: No DNA Found
**Scenario**: First run in new project
**Expected**: Create initial DNA
**Expected Output**: "🚀 DEV-STACKS FIRST RUN - Creating DNA..."

### Test Case 9.2: MCP Server Unavailable
**Scenario**: MCP Memory server down
**Expected**: Graceful degradation
**Expected Output**: "⚠️ Pattern memory unavailable - continuing without patterns"

### Test Case 9.3: Git Not Available
**Scenario**: Project without git
**Expected**: Disable undo/checkpoint features
**Expected Output**: "⚠️ Git not available - undo feature disabled"

### Test Case 9.4: Very Large Request
**Input**: "สร้างระบบทั้งหมดใหม่"
**Expected**: Scope warning
**Expected Output**: "⚠️ Scope too large. Consider breaking into smaller tasks..."

### Test Case 9.5: Conflicting Patterns
**Scenario**: Multiple patterns match task
**Expected**: Show options
**Expected Output**: "📚 Found multiple patterns. Select one: [1] Pattern A, [2] Pattern B"

---

## 10. Integration Tests

### Test Case 10.1: Full Happy Path
**Scenario**: User submits simple fix request
**Expected Flow**:
1. UserPromptSubmit → Intent Router → FIX_BUG, complexity 0.1
2. Team Selector → [Builder]
3. Quick Workflow → Builder executes
4. PostToolUse → Audit logged
5. Stop → Checkpoint saved

### Test Case 10.2: Full Complex Path
**Scenario**: User submits complex feature request
**Expected Flow**:
1. UserPromptSubmit → Intent Router → ADD_FEATURE, complexity 0.5
2. Team Selector → [Thinker, Builder, Tester]
3. Careful Workflow → Thinker plans → Builder implements → Tester verifies
4. PostToolUse → Audit logged
5. Pattern save prompt
6. Stop → Checkpoint saved

---

## Test Results Template

| Test Case | Status | Notes |
|-----------|--------|-------|
| 1.1 | ⏳ Pending | |
| 1.2 | ⏳ Pending | |
| ... | ... | |

---

**Status Legend**:
- ✅ Pass
- ❌ Fail
- ⏳ Pending
- ⚠️ Partial

---

## 11. Issues Analysis & Mitigations

> Generated: 2026-03-18
> Purpose: Document potential issues found during code review

### Critical Issues (FIXED)

| # | File | Issue | Fix Applied |
|---|------|-------|-------------|
| 1 | `hooks/PreCompact.md` | Used `mcp__filesystem__copy_file` which doesn't exist | Changed to read_text_file + write_file |
| 2 | `hooks/SessionStart.md` | Missing Step 6 for audit.jsonl creation | Added Step 6 |
| 3 | `hooks/SessionStart.md` | Duplicate content at end of file | Removed duplicate |
| 4 | `skills/report/report-engine/SKILL.md` | No fallback for missing data sources | Added Fallback Behavior section |
| 5 | `commands/report.md` | Missing Agents/Workflow sections in output | Added missing sections |

### Potential Issues (To Monitor)

| # | Component | Risk | Likelihood | Mitigation |
|---|-----------|------|------------|------------|
| 1 | All hooks | MCP server disconnected | Medium | Try/catch, fallback gracefully |
| 2 | PreToolUse | Guard config missing | Low | Default to BLOCK if config not found |
| 3 | SessionStart | Project scan fails | Low | Create minimal DNA, log warning |
| 4 | Report Engine | Large audit.jsonl | Low | Read in chunks, limit days parameter |
| 5 | All | Concurrent session writes | Low | Consider file locking in future |

### Test Cases for Issues

#### Test Case 11.1: PreCompact Without copy_file Tool
**Given:** Context compaction triggered
**When:** PreCompact hook runs
**Expected:**
- Read session log with `read_text_file`
- Write to archive with `write_file`
- Complete successfully

**Status:** ✅ FIXED

#### Test Case 11.2: Audit Report Without audit.jsonl
**Given:** `/dev-stacks:report audit` command
**When:** `.dev-stacks/logs/audit.jsonl` doesn't exist
**Expected:**
- Show: "⚠️ No audit data available. Audit logging starts with next session."
- Don't crash

**Status:** ✅ FIXED

#### Test Case 11.3: Pattern Report Without MCP Memory
**Given:** `/dev-stacks:report patterns` command
**When:** MCP Memory server unavailable
**Expected:**
- Show: "📚 Patterns: 0"
- Continue without crash

**Status:** ✅ FIXED

#### Test Case 11.4: Session Report Without Checkpoint
**Given:** `/dev-stacks:report session` command
**When:** `.dev-stacks/checkpoint.json` doesn't exist
**Expected:**
- Show: "No session data available"
- Continue without crash

**Status:** ✅ FIXED (fallback exists)

### MCP Tool Validation

| MCP Tool | Used In | Exists? | Status |
|----------|---------|---------|--------|
| `mcp__filesystem__read_text_file` | All hooks, skills | ✅ Yes | OK |
| `mcp__filesystem__write_file` | All hooks, skills | ✅ Yes | OK |
| `mcp__filesystem__create_directory` | SessionStart, PreCompact | ✅ Yes | OK |
| `mcp__filesystem__get_file_info` | SessionStart, PreToolUse | ✅ Yes | OK |
| `mcp__filesystem__directory_tree` | SessionStart | ✅ Yes | OK |
| `mcp__filesystem__copy_file` | PreCompact (old) | ❌ No | FIXED |
| `mcp__memory__search_nodes` | SessionStart, Report | ✅ Yes | OK |
| `mcp__memory__read_graph` | Report Engine | ✅ Yes | OK |
| `mcp__memory__create_entities` | Pattern save | ✅ Yes | OK |

---

## Summary

**Total Issues Found:** 5
**Critical Issues Fixed:** 5
**Remaining Risks:** 5 (low priority, to monitor)

All critical issues have been fixed. Plugin is ready for testing.
