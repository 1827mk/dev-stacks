---
name: PostToolUse
description: Audit logging - record actions and offer pattern saving after successful tasks.
---

# PostToolUse Hook

Executed after any tool use.

## Purpose

Post-action processing:
1. Log action to console and file
2. Write to audit trail
3. Track files touched
4. Update checkpoint
5. Offer to save as pattern (on success)

## Execution Steps

### Step 1: Log Action (ALWAYS OUTPUT TO CONSOLE + FILE)

**CONSOLE OUTPUT:**
```
📝 [DEV-STACKS] Tool: Edit | File: src/auth/login.ts | Status: ✅ Success
```

**LOG FILE (`.dev-stacks/logs/session-*.log`):**
```
[2026-03-18 10:30:15] [INFO] [PostToolUse] Tool: Edit | File: src/auth/login.ts | Status: SUCCESS
[2026-03-18 10:30:15] [INFO]   └─ Action: Added email validation
[2026-03-18 10:30:15] [INFO]   └─ Lines: +15, -3
```

For different tools:
```
📝 [DEV-STACKS] Tool: Read | File: README.md | Status: ✅ Success
📝 [DEV-STACKS] Tool: Bash | Command: git status | Status: ✅ Success
📝 [DEV-STACKS] Tool: Write | File: config.json | Status: ✅ Success
📝 [DEV-STACKS] Tool: Edit | File: auth.ts | Status: ❌ Failed | Error: File not found
```

### Step 2: Write to Audit Log

Append to `.dev-stacks/logs/audit.jsonl`:
```json
{
  "timestamp": "2026-03-18T10:30:00Z",
  "session_id": "abc123",
  "tool": "Edit",
  "action": "Modified file",
  "file": "src/auth/login.ts",
  "success": true
}
```

**LOG FILE:**
```
[2026-03-18 10:30:16] [INFO] [PostToolUse] Audit: Appended to audit.jsonl
```

### Step 3: Update Context

Track in session context:
- Files touched
- Decisions made
- Patterns used

**LOG FILE:**
```
[2026-03-18 10:30:17] [INFO] [PostToolUse] Context updated:
[2026-03-18 10:30:17] [INFO]   └─ Files touched: 2
[2026-03-18 10:30:17] [INFO]   └─ Decisions: 1
```

### Step 4: Update Checkpoint

Update `.dev-stacks/checkpoint.json`:
- Add to undo stack
- Update progress

**LOG FILE:**
```
[2026-03-18 10:30:18] [INFO] [PostToolUse] Checkpoint updated:
[2026-03-18 10:30:18] [INFO]   └─ Undo stack: 3 items
[2026-03-18 10:30:18] [INFO]   └─ Progress: 75%
```

### Step 5: Check for Pattern Save (on task success)

If task appears complete:
- Ask if user wants to save as pattern
- Extract pattern from successful task

**LOG FILE:**
```
[2026-03-18 10:30:20] [INFO] [PostToolUse] Task appears complete, offering pattern save...
```

## Log Output Format

### Tool Success - CONSOLE
```
📝 [DEV-STACKS] Tool: Edit | File: src/auth/login.ts | Status: ✅ Success
   └─ Action: Added email validation
```

### Tool Success - LOG FILE
```
[2026-03-18 10:30:15] [INFO] [PostToolUse] ═══════════════════════════════════════
[2026-03-18 10:30:15] [INFO] [PostToolUse] Tool: Edit | SUCCESS
[2026-03-18 10:30:15] [INFO]   └─ File: src/auth/login.ts
[2026-03-18 10:30:15] [INFO]   └─ Action: Added email validation
[2026-03-18 10:30:15] [INFO]   └─ Duration: 0.5s
[2026-03-18 10:30:15] [INFO] [PostToolUse] ═══════════════════════════════════════
```

### Tool Failure - CONSOLE
```
📝 [DEV-STACKS] Tool: Edit | File: src/auth/login.ts | Status: ❌ Failed
   └─ Error: File not found
```

### Tool Failure - LOG FILE
```
[2026-03-18 10:30:15] [ERROR] [PostToolUse] ═══════════════════════════════════════
[2026-03-18 10:30:15] [ERROR] [PostToolUse] Tool: Edit | FAILED
[2026-03-18 10:30:15] [ERROR]   └─ File: src/auth/login.ts
[2026-03-18 10:30:15] [ERROR]   └─ Error: File not found
[2026-03-18 10:30:15] [ERROR] [PostToolUse] ═══════════════════════════════════════
```

### Task Complete - CONSOLE
```
✅ [DEV-STACKS] Task Complete!
   └─ Files modified: 2
   └─ Duration: ~2 minutes
   └─ Workflow: Standard
```

### Task Complete - LOG FILE
```
[2026-03-18 10:32:00] [INFO] [PostToolUse] ═══════════════════════════════════════
[2026-03-18 10:32:00] [INFO] [PostToolUse] TASK COMPLETE
[2026-03-18 10:32:00] [INFO]   └─ Files modified: 2
[2026-03-18 10:32:00] [INFO]   └─ Duration: ~2 minutes
[2026-03-18 10:32:00] [INFO]   └─ Workflow: Standard
[2026-03-18 10:32:00] [INFO]   └─ Agents used: [Thinker, Builder]
[2026-03-18 10:32:00] [INFO] [PostToolUse] ═══════════════════════════════════════
```

## Audit Log Format

`.dev-stacks/logs/audit.jsonl` (JSON Lines):

```jsonl
{"timestamp":"2026-03-18T10:00:00Z","session_id":"abc123","tool":"Read","file":"README.md","success":true}
{"timestamp":"2026-03-18T10:01:00Z","session_id":"abc123","tool":"Edit","file":"README.md","action":"Fix typo","success":true}
{"timestamp":"2026-03-18T10:02:00Z","session_id":"abc123","tool":"Bash","command":"git status","success":true}
```

## Pattern Save Offer

After successful task completion:

**CONSOLE:**
```
✅ Task completed successfully!

📚 Would you like to save this as a pattern?
   Pattern name: "Login Form Validation"

   This pattern includes:
   • Email validation with regex
   • Password length check
   • Error message display

   Save pattern? [Y/n]
```

**LOG FILE:**
```
[2026-03-18 10:32:05] [INFO] [PostToolUse] Offering pattern save:
[2026-03-18 10:32:05] [INFO]   └─ Pattern name: Login Form Validation
[2026-03-18 10:32:05] [INFO]   └─ Trigger keywords: validation, form, login, email
```

On "Y":
```
📚 Pattern Saved!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Name: Login Form Validation
Trigger keywords: validation, form, login, email

This pattern will be suggested when similar tasks are detected.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**LOG FILE:**
```
[2026-03-18 10:32:10] [INFO] [PostToolUse] Pattern saved to MCP Memory:
[2026-03-18 10:32:10] [INFO]   └─ Name: Login Form Validation
[2026-03-18 10:32:10] [INFO]   └─ Keywords: validation, form, login, email
[2026-03-18 10:32:10] [INFO]   └─ Confidence: 1.0 (new pattern)
```

## Checkpoint Update

Update checkpoint after each action:

```json
{
  "session_id": "abc123",
  "timestamp": "2026-03-18T10:30:00Z",
  "state": {
    "phase": "BUILDING",
    "current_task": "Add login validation",
    "progress": 75
  },
  "context": {
    "files_touched": ["src/auth/login.ts"],
    "decisions_made": [],
    "patterns_used": []
  },
  "recovery": {
    "base_commit": "abc123",
    "undo_stack": [
      {
        "timestamp": "2026-03-18T10:25:00Z",
        "action": "Edit src/auth/login.ts",
        "files_modified": ["src/auth/login.ts"],
        "git_diff": "..."
      }
    ]
  }
}
```

## Pattern Save Offer

After successful task completion:

```
✅ Task completed successfully!

📚 Would you like to save this as a pattern?
   Pattern name: "Login Form Validation"

   This pattern includes:
   • Email validation with regex
   • Password length check
   • Error message display

   Save pattern? [Y/n]
```

On "Y":
```
📚 Pattern Saved!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Name: Login Form Validation
Trigger keywords: validation, form, login, email

This pattern will be suggested when similar tasks are detected.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**LOG FILE:**
```
[2026-03-18 10:32:10] [INFO] [PostToolUse] Pattern saved to MCP Memory:
[2026-03-18 10:32:10] [INFO]   └─ Name: Login Form Validation
[2026-03-18 10:32:10] [INFO]   └─ Keywords: validation, form, login, email
[2026-03-18 10:32:10] [INFO]   └─ Confidence: 1.0 (new pattern)
```

## MCP Tools Used

| Tool | Purpose |
|------|---------|
| `mcp__filesystem__write_file` | Write audit log, checkpoint, session log |
| `mcp__filesystem__read_text_file` | Read current checkpoint, session log, audit.jsonl (for append) |
| `mcp__memory__create_entities` | Save patterns |
| `mcp__memory__add_observations` | Update pattern stats |

**Note on audit.jsonl append:** Use `read_text_file` to read existing audit.jsonl, append new entry, then `write_file` to save.

## Notes

- **ALWAYS LOG** to both console and file
- Session log: `.dev-stacks/logs/session-*.log`
- Audit log: `.dev-stacks/logs/audit.jsonl`
- Silent operation for most actions (console minimal, file detailed)
- Only prompts on task success for pattern save
- Audit log is append-only
- Checkpoint enables undo
