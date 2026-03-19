---
name: checkpoint-manager
description: Manage session checkpoints for undo/redo functionality.
---

# Checkpoint Manager

Manage checkpoints in `.dev-stacks/checkpoint.json`.

## Structure

```json
{
  "session_id": "uuid",
  "timestamp": "2026-03-18T15:30:00Z",
  "state": {
    "phase": "IDLE|THINKING|BUILDING|TESTING",
    "current_task": "Task description",
    "progress": 50
  },
  "context": {
    "files_touched": ["src/auth.ts"],
    "decisions_made": [{"question": "JWT?", "answer": "yes"}],
    "patterns_used": ["Form Validation"]
  },
  "recovery": {
    "base_commit": "abc123",
    "undo_stack": [{"action": "Edit", "files_modified": ["src/auth.ts"], "git_diff": "..."}],
    "redo_stack": []
  }
}
```

## Operations

| Operation | Trigger | Action |
|-----------|---------|--------|
| Save | PostToolUse, Stop | Update state, push to undo_stack |
| Load | SessionStart | Restore state if same session |
| Undo | `/dev-stacks:undo` | Pop undo, apply reverse diff, push to redo |
| Redo | `/dev-stacks:redo` | Pop redo, apply diff, push to undo |

## Undo Levels

| Level | Description |
|-------|-------------|
| action | Last single action |
| phase | Entire phase |
| checkpoint | Last checkpoint |
| commit | Git reset to base |

## Output Format

```
CHECKPOINT SAVED
Session: [id]
Phase: [phase]
Progress: [%]
Undo depth: [n]

UNDO PREVIEW
Level: [level]
Changes: [files]
Proceed? [Y/n]
```

## Git Integration

| Action | Command |
|--------|---------|
| Get diff | `git diff` |
| Get commit | `git rev-parse HEAD` |
| Restore | `git checkout -- [file]` |
| Reset | `git reset --hard [commit]` |

## MCP Tools
- `read_text_file` - read checkpoint
- `write_file` - save checkpoint

## Config
- maxUndoLevels: 20
