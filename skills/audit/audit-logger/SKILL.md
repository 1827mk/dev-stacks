---
name: audit-logger
description: Log all Dev-Stacks actions for debugging and compliance.
---

# Audit Logger

Log actions to `.dev-stacks/audit.jsonl` (JSON Lines, append-only).

## Log Entry Format

```json
{
  "timestamp": "2026-03-18T15:30:00.123Z",
  "session_id": "abc123",
  "sequence": 42,
  "event_type": "TOOL_USE|GUARD|DECISION|ERROR",
  "data": {
    "tool": "Edit",
    "file": "src/auth.ts",
    "action": "Added validation",
    "success": true
  }
}
```

## Event Types

| Type | Data Fields |
|------|-------------|
| TOOL_USE | tool, file, action, success, duration_ms |
| GUARD | guard_type, file, action (BLOCK/ALLOW), reason |
| DECISION | question, answer, reason, agent |
| ERROR | error_type, message, tool, file, recovered |

## Logging Points

| Hook | Events |
|------|--------|
| SessionStart | Session initialized |
| UserPromptSubmit | Intent, workflow |
| PreToolUse | Guard checks |
| PostToolUse | Tool results |
| Stop | Session summary |

## Retention

| Data | Retention |
|------|-----------|
| Current session | Keep |
| Previous sessions | 30 days, then archive |
| Archived | 90 days, then delete |

## MCP Tools
- `write_file` - append to log
- `read_text_file` - query log

## Query Examples

```bash
# Count by type
cat .dev-stacks/audit.jsonl | jq -r '.event_type' | sort | uniq -c

# Find guard blocks
cat .dev-stacks/audit.jsonl | jq 'select(.event_type == "GUARD" and .data.action == "BLOCK")'
```
