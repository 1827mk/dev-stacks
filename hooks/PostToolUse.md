---
name: PostToolUse
description: Audit logging - record actions and offer pattern saving after successful tasks.
---

# PostToolUse Hook

Executed after any tool use.

## Purpose

Post-action processing:
1. Log action to audit trail
2. Track files touched
3. Update checkpoint
4. Offer to save as pattern (on success)

## Execution Steps

### Step 1: Log Action

Append to `.dev-stack/audit.jsonl`:
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

### Step 2: Update Context

Track in session context:
- Files touched
- Decisions made
- Patterns used

### Step 3: Update Checkpoint

Update `.dev-stack/checkpoint.json`:
- Add to undo stack
- Update progress

### Step 4: Check for Pattern Save (on task success)

If task appears complete:
- Ask if user wants to save as pattern
- Extract pattern from successful task

## Audit Log Format

`.dev-stack/audit.jsonl` (JSON Lines):

```jsonl
{"timestamp":"2026-03-18T10:00:00Z","session_id":"abc123","tool":"Read","file":"README.md","success":true}
{"timestamp":"2026-03-18T10:01:00Z","session_id":"abc123","tool":"Edit","file":"README.md","action":"Fix typo","success":true}
{"timestamp":"2026-03-18T10:02:00Z","session_id":"abc123","tool":"Bash","command":"git status","success":true}
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

## MCP Tools Used

| Tool | Purpose |
|------|---------|
| `mcp__filesystem__write_file` | Write audit log, checkpoint |
| `mcp__filesystem__read_text_file` | Read current checkpoint |
| `mcp__memory__create_entities` | Save patterns |
| `mcp__memory__add_observations` | Update pattern stats |

## Notes

- Silent operation for most actions
- Only prompts on task success for pattern save
- Audit log is append-only
- Checkpoint enables undo
