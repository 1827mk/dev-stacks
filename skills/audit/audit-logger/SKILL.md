---
name: audit-logger
description: Log all Dev-Stacks actions for debugging, compliance, and learning.
---

# Audit Logger

Logs all Dev-Stacks actions for debugging, compliance, and learning.

## Purpose

Record comprehensive audit trail:
- All tool uses
- All decisions
- All changes
- All guard actions

## Storage

**File**: `.dev-stack/audit.jsonl`

**Format**: JSON Lines (append-only)

## Log Entry Format

```json
{
  "timestamp": "2026-03-18T15:30:00.123Z",
  "session_id": "abc123-def456",
  "sequence": 42,
  "event_type": "TOOL_USE | GUARD | DECISION | ERROR",
  "data": {
    // Event-specific data
  }
}
```

## Event Types

### TOOL_USE

```json
{
  "timestamp": "2026-03-18T15:30:00.123Z",
  "session_id": "abc123-def456",
  "sequence": 42,
  "event_type": "TOOL_USE",
  "data": {
    "tool": "Edit",
    "file": "src/auth/login.ts",
    "action": "Added email validation",
    "success": true,
    "duration_ms": 150
  }
}
```

### GUARD

```json
{
  "timestamp": "2026-03-18T15:30:00.123Z",
  "session_id": "abc123-def456",
  "sequence": 43,
  "event_type": "GUARD",
  "data": {
    "guard_type": "scope",
    "file": ".env",
    "action": "BLOCK",
    "reason": "Protected file",
    "user_override": false
  }
}
```

### DECISION

```json
{
  "timestamp": "2026-03-18T15:30:00.123Z",
  "session_id": "abc123-def456",
  "sequence": 44,
  "event_type": "DECISION",
  "data": {
    "question": "Use JWT or session?",
    "answer": "JWT",
    "reason": "Stateless, easier to scale",
    "agent": "thinker"
  }
}
```

### ERROR

```json
{
  "timestamp": "2026-03-18T15:30:00.123Z",
  "session_id": "abc123-def456",
  "sequence": 45,
  "event_type": "ERROR",
  "data": {
    "error_type": "ToolError",
    "message": "File not found",
    "tool": "Read",
    "file": "src/missing.ts",
    "recovered": true
  }
}
```

## Logging Points

### Hook Events

| Hook | Events Logged |
|------|---------------|
| SessionStart | Session initialized, DNA loaded |
| UserPromptSubmit | Intent detected, workflow selected |
| PreToolUse | Guard checks, confirmations |
| PostToolUse | Tool results, pattern saves |
| Stop | Session ended, summary |

### Agent Events

| Agent | Events Logged |
|-------|---------------|
| Thinker | Analysis complete, research done, plan created |
| Builder | Implementation started, changes made, complete |
| Tester | Tests run, verification complete, issues found |

## Retention Policy

| Data | Retention | Action |
|------|-----------|--------|
| Current session | Indefinite | Keep |
| Previous sessions | 30 days | Archive |
| Archived logs | 90 days | Delete |

## Archive Format

Archived to: `.dev-stack/archive/audit-YYYY-MM-DD.jsonl.gz`

## Query Examples

### Count events by type
```bash
cat .dev-stack/audit.jsonl | jq -r '.event_type' | sort | uniq -c
```

### Find all guard blocks
```bash
cat .dev-stack/audit.jsonl | jq 'select(.event_type == "GUARD" and .data.action == "BLOCK")'
```

### Get session summary
```bash
cat .dev-stack/audit.jsonl | jq 'select(.session_id == "abc123")' | wc -l
```

## MCP Tools Used

| Tool | Purpose |
|------|---------|
| `mcp__filesystem__write_file` | Append to log |
| `mcp__filesystem__read_text_file` | Read log for queries |

## Notes

- Append-only for integrity
- Compressed when archived
- Can be disabled via config
- Used for debugging and learning
