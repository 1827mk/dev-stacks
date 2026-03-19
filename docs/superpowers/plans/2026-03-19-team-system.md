# Team System Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Implement full team orchestration system with state machine for Dev-Stacks plugin

**Architecture:** Lightweight orchestrator skill manages state transitions and dispatches agents (Thinker, Builder, Tester) in staged workflow. Uses hybrid communication (MCP Memory + Task System). Agents have full autonomy to select MCP tools.

**Tech Stack:** Claude Code plugin system, MCP servers (memory, filesystem, context7, web_reader, etc.), Bash hooks

**Spec:** `docs/superpowers/specs/2026-03-19-team-system-design.md`

---

## File Structure

```
dev-stacks/
├── skills/core/orchestrator/
│   └── SKILL.md              ← CREATE: Main orchestrator skill
├── hooks/
│   └── user-prompt-submit.sh ← MODIFY: Add orchestration invoke
├── config/
│   └── defaults.json         ← MODIFY: Add orchestrator config
├── agents/
│   ├── thinker.md            ← MODIFY: Add MCP autonomy section
│   ├── builder.md            ← MODIFY: Add MCP autonomy section
│   └── tester.md             ← MODIFY: Add MCP autonomy section
└── .dev-stacks/
    └── state.json            ← AUTO-CREATED at runtime
```

---

## Task 1: Create Orchestrator Skill

**Files:**
- Create: `skills/core/orchestrator/SKILL.md`

- [ ] **Step 1: Create orchestrator directory**

```bash
mkdir -p /Users/tanaphat.oiu/I-Me/MyProject/dev-stacks/skills/core/orchestrator
```

- [ ] **Step 2: Write orchestrator SKILL.md**

```markdown
---
name: orchestrator
description: Automatically invoked after UserPromptSubmit hook.
             Manages team workflow, state transitions, and agent dispatch.
             Use when hook outputs "📋 ORCHESTRATION: Use Skill tool..."
---

# Dev-Stacks Orchestrator

You are the orchestrator. Your ONLY job is to manage the team workflow.

## Your Responsibilities

1. Read routing context from hook output
2. Manage state transitions
3. Dispatch appropriate agents
4. Handle errors by asking user

## What You MUST NOT Do

- ❌ Implement code yourself
- ❌ Make changes to files
- ❌ Skip the confirm step
- ❌ Ignore errors

## Process

### Step 1: Read Context

Look for hook output in conversation:
```
🔍 [DEV-STACKS] Intent: ADD_FEATURE | Complexity: 0.35 | Workflow: Standard
```

Extract:
- Intent (FIX_BUG, ADD_FEATURE, etc.)
- Complexity score (0.0-1.0)
- Workflow (Quick, Standard, Careful, Full)

### Step 2: Load or Create State

Read state file:
```bash
Read: .dev-stacks/state.json
```

If not exists, create:
```json
{
  "version": "1.0.0",
  "session_id": "sess-<timestamp>",
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
    "created": "<ISO timestamp>",
    "last_updated": "<ISO timestamp>"
  }
}
```

### Step 3: State Machine

Follow these state transitions:

| State | Trigger | Next State | Action |
|-------|---------|------------|--------|
| IDLE | user_input | ANALYZING | Parse intent, update state |
| ANALYZING | done | PLANNING | Dispatch Thinker |
| PLANNING | done | CONFIRM | Show plan to user |
| CONFIRM | approve | BUILDING | Dispatch Builder |
| CONFIRM | reject | IDLE | Clean up, report |
| BUILDING | done + complexity<0.4 | DONE | Report results |
| BUILDING | done + complexity>=0.4 | TESTING | Dispatch Tester |
| TESTING | done | DONE | Report results |
| ANY | error | ERROR | Ask user |

### Step 4: Dispatch Agents

Use Agent tool with correct subagent_type:

**For Thinker:**
```
Agent tool:
  subagent_type: "dev-stacks:thinker"
  description: "Plan [task description]"
  prompt: |
    Task: [user's task from state]

    You have FULL access to all MCP servers and skills.
    SELECT the best tools yourself based on what you need.

    Available: context7, web_reader, WebSearch, fetch, serena,
               memory, filesystem, sequentialthinking, doc-forge,
               chrome-devtools, and all skills.

    After analysis, output your plan in this format:
    🧠 THINKER ANALYSIS
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    Task: [description]
    Files to modify: [list]
    Approach: [description]
    Risks: [list]
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**For Builder:**
```
Agent tool:
  subagent_type: "dev-stacks:builder"
  description: "Implement [task description]"
  prompt: |
    Task: [user's task]
    Plan: [from Thinker's output]

    You have FULL access to all MCP servers and skills.
    SELECT the best tools yourself.

    Implement the plan. Report changes made.
```

**For Tester:**
```
Agent tool:
  subagent_type: "dev-stacks:tester"
  description: "Verify [task description]"
  prompt: |
    Task: [user's task]
    Changes: [from Builder's output]

    Verify the implementation meets requirements.
    Run tests if available. Check edge cases.
```

### Step 5: Confirm with User

After Thinker completes, show plan and ask:

```
Use AskUserQuestion:
  questions:
    - question: "Plan ready. Proceed with implementation?"
      header: "Confirm"
      options:
        - label: "Yes, proceed"
          description: "Start implementation with this plan"
        - label: "Modify plan"
          description: "I want to adjust the approach"
        - label: "Cancel"
          description: "Don't proceed with this task"
```

### Step 6: Handle Errors

When any agent reports error, use AskUserQuestion:

```
questions:
  - question: "Error occurred: [error details]. What should I do?"
    header: "Error"
    options:
      - label: "Retry"
        description: "Try the same operation again"
      - label: "Re-plan"
        description: "Return to Thinker for new approach"
      - label: "Cancel task"
        description: "Abort this task"
      - label: "Continue anyway"
        description: "Proceed despite error (risky)"
```

### Step 7: Update State

After each transition, update state file:

```bash
Edit: .dev-stacks/state.json
```

Update:
- current_state
- task info (if IDLE → ANALYZING)
- plan (after Thinker)
- progress flags
- timestamps

### Step 8: Save to Memory

Store findings in MCP Memory:

```
mcp__memory__create_entities:
  entities:
    - name: "task-<id>-analysis"
      entityType: "dev-stacks-analysis"
      observations: [...]
    - name: "task-<id>-plan"
      entityType: "dev-stacks-plan"
      observations: [...]
```

### Step 9: Report Results

When DONE:

```
✅ TASK COMPLETE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Task: [original task]
Changes:
- [file 1]: [what changed]
- [file 2]: [what changed]

Pattern saved? [Yes/No]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Workflow Examples

### Quick Workflow (complexity < 0.2)
```
IDLE → ANALYZING → BUILDING → DONE
(Skip Thinker, Skip Tester)
```

### Standard Workflow (0.2-0.39)
```
IDLE → ANALYZING → PLANNING → CONFIRM → BUILDING → DONE
(Thinker + Builder)
```

### Careful/Full Workflow (>= 0.4)
```
IDLE → ANALYZING → PLANNING → CONFIRM → BUILDING → TESTING → DONE
(Thinker + Builder + Tester)
```
```

- [ ] **Step 3: Commit orchestrator skill**

```bash
git add skills/core/orchestrator/SKILL.md
git commit -m "$(cat <<'EOF'
feat: add orchestrator skill for team system

- State machine with IDLE→ANALYZING→PLANNING→CONFIRM→BUILDING→TESTING→DONE
- Agent dispatch with full MCP autonomy
- User confirmation before implementation
- Error handling with user options
- State persistence in .dev-stacks/state.json

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>
EOF
)"
```

---

## Task 2: Modify Hook to Invoke Orchestrator

**Files:**
- Modify: `hooks/user-prompt-submit.sh`

- [ ] **Step 1: Read current hook file**

```bash
Read: hooks/user-prompt-submit.sh
```

- [ ] **Step 2: Modify output section (lines 67-72)**

Change from:
```bash
# Output routing info (stdout is added as context)
cat << ROUTING
🔍 [DEV-STACKS] Intent: $INTENT | Complexity: $COMPLEXITY | Workflow: $WORKFLOW
ROUTING

exit 0
```

To:
```bash
# Output routing info + orchestration instruction
cat << ROUTING
🔍 [DEV-STACKS] Intent: $INTENT | Complexity: $COMPLEXITY | Workflow: $WORKFLOW

📋 ORCHESTRATION INSTRUCTION:
Invoke the orchestrator skill to manage this task:
  • Use Skill tool with skill="dev-stacks:orchestrator"
  • Orchestrator will handle state machine and agent dispatch
  • Do NOT implement directly - let the team handle it
ROUTING

exit 0
```

- [ ] **Step 3: Commit hook changes**

```bash
git add hooks/user-prompt-submit.sh
git commit -m "$(cat <<'EOF'
feat(hook): add orchestrator invocation instruction

Hook now instructs LLM to invoke orchestrator skill
for team-based task handling.

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>
EOF
)"
```

---

## Task 3: Add Orchestrator Config

**Files:**
- Modify: `config/defaults.json`

- [ ] **Step 1: Read current config**

```bash
Read: config/defaults.json
```

- [ ] **Step 2: Add orchestrator settings**

Add after existing content:
```json
  "orchestrator": {
    "enabled": true,
    "auto_invoke": true,
    "confirm_required": true,
    "state_file": ".dev-stacks/state.json",
    "error_handling": "ask_user",
    "max_retries": 3,
    "workflows": {
      "quick": { "complexity_range": [0.0, 0.19], "agents": ["builder"] },
      "standard": { "complexity_range": [0.2, 0.39], "agents": ["thinker", "builder"] },
      "careful": { "complexity_range": [0.4, 0.59], "agents": ["thinker", "builder", "tester"] },
      "full": { "complexity_range": [0.6, 1.0], "agents": ["thinker", "builder", "tester"], "require_confirmation": true }
    }
  }
```

- [ ] **Step 3: Commit config changes**

```bash
git add config/defaults.json
git commit -m "$(cat <<'EOF'
feat(config): add orchestrator settings

- Enable orchestrator with auto-invoke
- Configure workflow thresholds and agent assignments
- Set error handling to ask_user mode

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>
EOF
)"
```

---

## Task 4: Update Thinker Agent with MCP Autonomy

**Files:**
- Modify: `agents/thinker.md`

- [ ] **Step 1: Read current thinker.md**

```bash
Read: agents/thinker.md
```

- [ ] **Step 2: Add MCP Autonomy section after "Research Tools Available"**

Add new section:
```markdown
## Autonomous Tool Selection

You have FULL ACCESS to all MCP servers and skills. SELECT YOURSELF.

### Available Resources

| Type | Examples | How to Access |
|------|----------|---------------|
| **MCP Servers** | context7, web_reader, WebSearch, fetch, serena, memory, filesystem, sequentialthinking, doc-forge, chrome-devtools | Use directly (mcp__* tools) |
| **Skills** | superpowers:*, dev-stacks:*, plugin-dev:* | Use Skill tool |
| **Built-in** | Read, Write, Edit, Bash, Glob, Grep | Use directly |

### Decision Framework

When you need information or capability:

```
1. What do I need?
   ├── Library docs → context7
   ├── Web content → web_reader / fetch
   ├── Search → WebSearch
   ├── Code patterns → serena + memory
   ├── Complex problem → sequentialthinking
   ├── Documents → doc-forge
   └── Skill match → Skill tool

2. Try it
3. If not enough, try another
4. Combine multiple if needed
5. Report what you used
```

### No Permission Needed

- ✅ Use any MCP tool when appropriate
- ✅ Invoke any skill when description matches
- ✅ Combine multiple tools
- ❌ Don't ask "should I use X?" - just use it if helpful
```

- [ ] **Step 3: Commit thinker changes**

```bash
git add agents/thinker.md
git commit -m "$(cat <<'EOF'
feat(agent): add MCP autonomy to Thinker

Thinker can now autonomously select and use any
MCP server or skill without permission.

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>
EOF
)"
```

---

## Task 5: Update Builder Agent with MCP Autonomy

**Files:**
- Modify: `agents/builder.md`

- [ ] **Step 1: Read current builder.md**

```bash
Read: agents/builder.md
```

- [ ] **Step 2: Add MCP Autonomy section (same as Task 4)**

Add after "Research Tools Available":
```markdown
## Autonomous Tool Selection

You have FULL ACCESS to all MCP servers and skills. SELECT YOURSELF.

### Available Resources

| Type | Examples | How to Access |
|------|----------|---------------|
| **MCP Servers** | context7, web_reader, WebSearch, fetch, serena, memory, filesystem, sequentialthinking, doc-forge, chrome-devtools | Use directly (mcp__* tools) |
| **Skills** | superpowers:*, dev-stacks:*, plugin-dev:* | Use Skill tool |
| **Built-in** | Read, Write, Edit, Bash, Glob, Grep | Use directly |

### Decision Framework

When you need information or capability:

```
1. What do I need?
   ├── API docs → context7
   ├── Code examples → web_reader
   ├── Error solutions → WebSearch
   ├── Codebase patterns → serena
   ├── Implementation help → Skill tool
   └── File operations → filesystem / built-in

2. Try it
3. If not enough, try another
4. Combine multiple if needed
5. Report what you used
```

### No Permission Needed

- ✅ Use any MCP tool when appropriate
- ✅ Invoke any skill when description matches
- ✅ Combine multiple tools
- ❌ Don't ask "should I use X?" - just use it if helpful
```

- [ ] **Step 3: Commit builder changes**

```bash
git add agents/builder.md
git commit -m "$(cat <<'EOF'
feat(agent): add MCP autonomy to Builder

Builder can now autonomously select and use any
MCP server or skill without permission.

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>
EOF
)"
```

---

## Task 6: Update Tester Agent with MCP Autonomy

**Files:**
- Modify: `agents/tester.md`

- [ ] **Step 1: Read current tester.md**

```bash
Read: agents/tester.md
```

- [ ] **Step 2: Add MCP Autonomy section**

Add after existing tool sections:
```markdown
## Autonomous Tool Selection

You have FULL ACCESS to all MCP servers and skills. SELECT YOURSELF.

### Available Resources

| Type | Examples | How to Access |
|------|----------|---------------|
| **MCP Servers** | context7, web_reader, WebSearch, fetch, serena, memory, filesystem, chrome-devtools | Use directly (mcp__* tools) |
| **Skills** | superpowers:*, dev-stacks:* | Use Skill tool |
| **Built-in** | Read, Bash, Glob, Grep | Use directly |

### Decision Framework

When you need to verify or test:

```
1. What do I need?
   ├── Testing framework docs → context7
   ├── Testing patterns → WebSearch
   ├── Code coverage → serena
   ├── Browser testing → chrome-devtools
   ├── Run tests → Bash
   └── Read test files → Read / filesystem

2. Try it
3. If not enough, try another
4. Combine multiple if needed
5. Report what you used
```

### No Permission Needed

- ✅ Use any MCP tool when appropriate
- ✅ Invoke any skill when description matches
- ✅ Combine multiple tools
- ❌ Don't ask "should I use X?" - just use it if helpful
```

- [ ] **Step 3: Commit tester changes**

```bash
git add agents/tester.md
git commit -m "$(cat <<'EOF'
feat(agent): add MCP autonomy to Tester

Tester can now autonomously select and use any
MCP server or skill without permission.

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>
EOF
)"
```

---

## Task 7: Integration Test

**Files:**
- Test: Manual testing

- [ ] **Step 1: Reload plugin in Claude Code**

Exit and restart Claude Code session to load updated plugin.

- [ ] **Step 2: Test Quick workflow**

Input: "แก้ typo ใน README"

Expected:
1. Hook outputs routing info
2. Orchestrator invoked
3. Goes directly to Builder (skip Thinker)
4. Reports completion

- [ ] **Step 3: Test Standard workflow**

Input: "เพิ่ม console.log ใน function main"

Expected:
1. Hook outputs routing info
2. Orchestrator invoked
3. Thinker analyzes and plans
4. User confirmation requested
5. After confirm, Builder implements
6. Reports completion

- [ ] **Step 4: Test error handling**

Simulate error during implementation.

Expected:
1. Orchestrator catches error
2. Asks user: Retry / Re-plan / Cancel / Continue

- [ ] **Step 5: Final commit**

```bash
git add -A
git commit -m "$(cat <<'EOF'
test: integration test for team system

Verified:
- Quick workflow (Builder only)
- Standard workflow (Thinker + Builder)
- Error handling with user options
- State persistence

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>
EOF
)"
```

---

## Summary

| Task | Files | Purpose |
|------|-------|---------|
| 1 | `skills/core/orchestrator/SKILL.md` | Create orchestrator |
| 2 | `hooks/user-prompt-submit.sh` | Add invoke instruction |
| 3 | `config/defaults.json` | Add config |
| 4 | `agents/thinker.md` | Add MCP autonomy |
| 5 | `agents/builder.md` | Add MCP autonomy |
| 6 | `agents/tester.md` | Add MCP autonomy |
| 7 | Manual | Integration test |

**Total commits: 7**
