---
name: Stop
description: Session end - save checkpoint and summarize session.
---

# Stop Hook

Executed when Claude Code session ends.

## Purpose

Clean up and save session state:
1. Log session end
2. Save final checkpoint
3. Summarize session
4. Update pattern stats
5. Clean up old data

## Execution Steps

### Step 1: Log Session End

**CONSOLE:**
```
🔍 [DEV-STACKS] Session ending... Saving state.
```

**LOG FILE (`.dev-stacks/logs/session-*.log`):**
```
[2026-03-18 12:00:00] [INFO] ═══════════════════════════════════════════════════
[2026-03-18 12:00:00] [INFO] DEV-STACKS SESSION END
[2026-03-18 12:00:00] [INFO] Session ID: abc123-def456
[2026-03-18 12:00:00] [INFO] Duration: 45 minutes
[2026-03-18 12:00:00] [INFO] ═══════════════════════════════════════════════════
[2026-03-18 12:00:00] [INFO] Step 1/5: Saving checkpoint...
```

### Step 2: Save Checkpoint

Write final checkpoint to `.dev-stacks/checkpoint.json`:
- Current session state
- All files touched
- All decisions made
- Complete undo stack

**LOG FILE:**
```
[2026-03-18 12:00:01] [INFO] Step 2/5: Saving checkpoint...
[2026-03-18 12:00:01] [INFO]   └─ Checkpoint saved: .dev-stacks/checkpoint.json
[2026-03-18 12:00:01] [INFO]   └─ Files touched: 2
[2026-03-18 12:00:01] [INFO]   └─ Undo stack: 5 items
```

### Step 3: Update Pattern Stats

For patterns used in session:
- Increment use_count
- Update last_used_at
- Update success/failure counts

**LOG FILE:**
```
[2026-03-18 12:00:02] [INFO] Step 3/5: Updating pattern stats...
[2026-03-18 12:00:02] [INFO]   └─ Patterns used: 1
[2026-03-18 12:00:02] [INFO]   └─ Pattern: "Form Validation Pattern" (success)
```

### Step 4: Session Summary

**CONSOLE:**
```
📊 SESSION SUMMARY
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Duration: 45 minutes
Tasks completed: 2
Files touched: 2
Patterns used: 1
Patterns learned: 1

Checkpoint saved. Session can be resumed.
Log file: .dev-stacks/logs/session-2026-03-18-103000.log
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**LOG FILE:**
```
[2026-03-18 12:00:03] [INFO] Step 4/5: Session summary...
[2026-03-18 12:00:03] [INFO]   └─ Duration: 45 minutes
[2026-03-18 12:00:03] [INFO]   └─ Tasks completed: 2
[2026-03-18 12:00:03] [INFO]   └─ Files touched: 2
[2026-03-18 12:00:03] [INFO]   └─ Patterns used: 1
[2026-03-18 12:00:03] [INFO]   └─ Patterns learned: 1
```

### Step 5: Cleanup

- Archive old audit logs (> 30 days)
- Remove low-confidence patterns (< 0.3, unused > 30 days)
- Keep last 3 session checkpoints

**LOG FILE:**
```
[2026-03-18 12:00:04] [INFO] Step 5/5: Cleanup...
[2026-03-18 12:00:04] [INFO]   └─ Old logs archived: 0
[2026-03-18 12:00:04] [INFO]   └─ Low-confidence patterns removed: 0
[2026-03-18 12:00:04] [INFO]   └─ Old checkpoints kept: 3
```

### Final Log Entry

**LOG FILE:**
```
[2026-03-18 12:00:05] [INFO] ═══════════════════════════════════════════════════
[2026-03-18 12:00:05] [INFO] SESSION ENDED - Checkpoint saved for recovery
[2026-03-18 12:00:05] [INFO] Log file: .dev-stacks/logs/session-2026-03-18-103000.log
[2026-03-18 12:00:05] [INFO] ═══════════════════════════════════════════════════
```

## Checkpoint Format

Final checkpoint saved:

```json
{
  "session_id": "abc123-def456",
  "timestamp": "2026-03-18T12:00:00Z",
  "state": {
    "phase": "IDLE",
    "current_task": null,
    "progress": 100
  },
  "context": {
    "files_touched": [
      "src/auth/login.ts",
      "src/auth/login.test.ts"
    ],
    "decisions_made": [
      {
        "question": "Use JWT or session?",
        "answer": "JWT",
        "reason": "Stateless, easier to scale"
      }
    ],
    "patterns_used": ["Form Validation Pattern"]
  },
  "recovery": {
    "base_commit": "abc123def",
    "undo_stack": [...]
  },
  "summary": {
    "tasks_completed": 2,
    "duration": "45 minutes",
    "log_file": ".dev-stacks/logs/session-2026-03-18-103000.log"
  }
}
```

## Session Log Retention

```
.dev-stacks/logs/
├── session-2026-03-18-100000.log  (today)
├── session-2026-03-17-140000.log  (yesterday)
├── session-2026-03-16-090000.log  (2 days ago)
├── audit.jsonl                      (all time)
└── archive/                         (older logs)
    └── session-2026-02-*.log.gz
```

## MCP Tools Used

| Tool | Purpose |
|------|---------|
| `mcp__filesystem__write_file` | Save checkpoint |
| `mcp__filesystem__read_text_file` | Read current checkpoint, session log |
| `mcp__filesystem__get_file_info` | Check file ages |
| `mcp__memory__add_observations` | Update pattern stats |
| `mcp__memory__delete_entities` | Remove old patterns |

## Notes

- **ALWAYS LOG** session end to both console and file
- Checkpoint enables session recovery
- Patterns are persisted in MCP Memory
- Cleanup runs automatically
- User can resume from checkpoint if session interrupted
- Log files are kept for debugging and audit purposes
