---
name: checkpoint-manager
description: Manage session checkpoints - save, load, and restore session state using MCP Filesystem.
---

# Checkpoint Manager

Manages session checkpoints for recovery and undo functionality.

## Purpose

Handle all checkpoint operations:
- Save session state
- Load checkpoint
- Restore session
- Manage undo stack

## Storage

**File**: `.dev-stack/checkpoint.json`

**Format**:
```json
{
  "session_id": "uuid-v4",
  "timestamp": "2026-03-18T15:30:00Z",
  "state": {
    "phase": "IDLE | THINKING | BUILDING | TESTING",
    "current_task": "Task description",
    "progress": 0-100
  },
  "context": {
    "files_touched": ["src/auth/login.ts"],
    "decisions_made": [
      {
        "question": "Use JWT or session?",
        "answer": "JWT",
        "reason": "Stateless"
      }
    ],
    "patterns_used": ["Pattern: Form Validation"]
  },
  "recovery": {
    "base_commit": "abc123def",
    "undo_stack": [
      {
        "timestamp": "2026-03-18T15:25:00Z",
        "action": "Edit src/auth/login.ts",
        "files_modified": ["src/auth/login.ts"],
        "files_created": [],
        "files_deleted": [],
        "git_diff": "--- a/...\n+++ b/..."
      }
    ],
    "redo_stack": []
  },
  "next_steps": ["Run tests", "Update docs"]
}
```

## Operations

### Save Checkpoint

Save current session state.

**When called**:
- After each tool use (PostToolUse hook)
- On session end (Stop hook)
- On explicit save request

**Process**:
1. Read current checkpoint (if exists)
2. Update state and context
3. Add to undo stack if changes made
4. Write to `.dev-stack/checkpoint.json`

**MCP Tools**:
- `mcp__filesystem__read_text_file` - Read existing
- `mcp__filesystem__write_file` - Save checkpoint

---

### Load Checkpoint

Load session state from checkpoint.

**When called**:
- On session start (SessionStart hook)
- On explicit load request

**Process**:
1. Check if checkpoint exists
2. Validate session ID
3. If different session, offer recovery
4. If same session, restore state

**MCP Tools**:
- `mcp__filesystem__read_text_file` - Read checkpoint
- `mcp__filesystem__get_file_info` - Check existence

---

### Undo Operation

Revert to previous state.

**When called**:
- `/ds:undo` command
- Explicit undo request

**Process**:
1. Pop from undo_stack
2. Show preview of changes
3. On confirmation:
   - Apply git diff (reverse)
   - Restore files
   - Update checkpoint
4. Push to redo_stack

**Undo Levels**:

| Level | Description |
|-------|-------------|
| `action` | Last single action |
| `phase` | Entire phase (think/build/test) |
| `checkpoint` | Last checkpoint |
| `commit` | Git reset to base commit |

---

### Redo Operation

Restore undone changes.

**When called**:
- `/ds:redo` command

**Process**:
1. Pop from redo_stack
2. Show preview
3. On confirmation:
   - Apply git diff
   - Update files
   - Push to undo_stack

---

## Output Formats

### Save Success
```
💾 CHECKPOINT SAVED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Session: [session_id]
Phase: [current phase]
Progress: [%]
Files touched: [count]
Undo depth: [count]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Load Success
```
📂 CHECKPOINT LOADED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Session: [session_id]
Last saved: [time] ago
Phase: [phase]
Task: [current task]

Files touched: [count]
Patterns used: [count]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Recovery Offer
```
🔄 SESSION RECOVERY
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Found previous session: [session_id]
Saved: [time] ago

State:
  - Phase: [phase]
  - Task: [task description]
  - Progress: [%]

Options:
  1. Continue from checkpoint
  2. Start fresh

Reply with 1 or 2.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Undo Preview
```
⏪ UNDO PREVIEW
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Level: [action | phase | checkpoint | commit]
Action: [what will be undone]
Time: [when action was done]

Changes to revert:
   - [file1] ([modified | created | deleted])
   - [file2] ([modified | created | deleted])

Preview:
   [diff preview or summary]

Proceed? [Y/n]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Redo Preview
```
⏩ REDO PREVIEW
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Action: [what will be redone]
Time: [when action was undone]

Changes to restore:
   - [file1] ([modified | created | deleted])
   - [file2] ([modified | created | deleted])

Proceed? [Y/n]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Configuration

From `config/defaults.json`:

```json
{
  "pattern": {
    "maxUndoLevels": 20
  }
}
```

## Error Handling

### No Checkpoint Found
```
📂 CHECKPOINT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
No checkpoint found.
Starting fresh session.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Nothing to Undo
```
⏪ UNDO
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Nothing to undo.
Undo stack is empty.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Nothing to Redo
```
⏩ REDO
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Nothing to redo.
Redo stack is empty.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Git Integration

For file recovery, uses git operations:

| Action | Git Command |
|--------|-------------|
| Get diff | `git diff` |
| Get base commit | `git rev-parse HEAD` |
| Restore file | `git checkout -- [file]` |
| Full reset | `git reset --hard [commit]` |

## Notes

- Checkpoint saved after every tool use
- Undo stack limited to configured max (default: 20)
- Redo stack cleared on new action
- All operations logged to audit trail
