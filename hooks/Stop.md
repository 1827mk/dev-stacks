---
name: Stop
description: Session end - save checkpoint and summarize session.
---

# Stop Hook

Executed when Claude Code session ends.

## Purpose

Clean up and save session state:
1. Save final checkpoint
2. Summarize session
3. Clean up old data

## Execution Steps

### Step 1: Save Checkpoint

Write final checkpoint to `.dev-stack/checkpoint.json`:
- Current session state
- All files touched
- All decisions made
- Complete undo stack

### Step 2: Update Pattern Stats

For patterns used in session:
- Increment use_count
- Update last_used_at
- Update success/failure counts

### Step 3: Session Summary

Display session summary:
```
📊 SESSION SUMMARY
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Duration: [duration]
Tasks completed: [count]
Files touched: [count]
Patterns used: [count]
Patterns learned: [count]

Checkpoint saved. Session can be resumed.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Step 4: Cleanup

- Archive old audit logs (> 30 days)
- Remove low-confidence patterns (< 0.3, unused > 30 days)
- Keep last 3 session checkpoints

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
    "duration": "45 minutes"
  }
}
```

## MCP Tools Used

| Tool | Purpose |
|------|---------|
| `mcp__filesystem__write_file` | Save checkpoint |
| `mcp__filesystem__read_text_file` | Read current checkpoint |
| `mcp__memory__add_observations` | Update pattern stats |
| `mcp__memory__delete_entities` | Remove old patterns |

## Notes

- Checkpoint enables session recovery
- Patterns are persisted in MCP Memory
- Cleanup runs automatically
- User can resume from checkpoint if session interrupted
