---
name: doctor
description: Diagnose and recover Dev-Stacks - check system health, fix issues, and reset if needed.
---

# /ds:doctor

Diagnose and recover Dev-Stacks system.

## Usage

```
/ds:doctor [action] [component] [--confirm]
```

## Actions

| Action | Description |
|--------|-------------|
| `check` | Check system health (default) |
| `fix` | Fix detected issues |
| `reset` | Reset components (destructive) |

---

## Action: check

Check system health.

```
/ds:doctor
```

### Output

```
🏥 DEV-STACKS DOCTOR
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Checking system health...

DNA:
   ✅ Valid (2.3 KB)
   • Project: my-app (FULLSTACK)
   • Patterns: 3
   • Risk areas: 2

Checkpoint:
   ✅ Valid (last 5 minutes ago)
   • Session: abc123
   • Undo stack: 3 entries

Pattern Memory:
   ✅ Connected to MCP Memory
   • Patterns: 3 stored
   • Index: OK

Audit Log:
   ⚠️ Large (2.5 MB) - consider cleanup
   • Entries: 1,234
   • Oldest: 30 days ago

Guards:
   ✅ All active
   • Scope: 12 protected paths
   • Secret: 8 patterns
   • Bash: 15 blocked commands

Agents:
   ✅ All available
   • Thinker: Ready
   • Builder: Ready
   • Tester: Ready

Status: ✅ HEALTHY
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Action: fix

Fix detected issues automatically.

```
/ds:doctor fix
```

### Output

```
🏥 DEV-STACKS DOCTOR - FIX MODE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Scanning for issues...

Issues Found:
   1. Audit log is large (2.5 MB)

Fixing...

✅ Fixed: Audit log archived
   • Archived: audit-2026-03-18.jsonl
   • Freed: 2.3 MB
   • Current size: 0.2 MB

All issues resolved.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Action: reset

Reset components (destructive - requires --confirm).

```
/ds:doctor reset dna --confirm
```

### Components

| Component | Description |
|-----------|-------------|
| `dna` | Rebuild DNA from scratch |
| `patterns` | Clear all patterns |
| `checkpoint` | Clear session state |
| `audit` | Clear audit log |
| `all` | Factory reset |

### Output

```
🏥 DEV-STACKS DOCTOR - RESET MODE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚠️ DESTRUCTIVE OPERATION

Component: dna
Action: Rebuild from scratch

This will:
   • Delete current DNA
   • Rescan entire project
   • Create new DNA

Current DNA:
   • Project: my-app
   • Patterns: 3
   • Risk areas: 2

Proceed with reset? [Y/n]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[If Y]

🏥 DEV-STACKS DOCTOR - RESETTING
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Deleting current DNA...
Scanning project...
Building new DNA...

✅ DNA Reset Complete
   • Project: my-app (FULLSTACK)
   • Patterns: 0 (will learn anew)
   • Risk areas: 2
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Diagnostics Performed

| Check | Description |
|-------|-------------|
| DNA | File exists, valid JSON, has required fields |
| Checkpoint | File exists, valid JSON, session matches |
| Pattern Memory | MCP Memory connected, patterns queryable |
| Audit Log | File exists, not too large (< 5 MB) |
| Guards | Config files valid, patterns valid |
| Agents | Agent files exist, valid frontmatter |

---

## Auto-Fix Actions

| Issue | Fix |
|-------|-----|
| Missing DNA | Create new DNA |
| Corrupted DNA | Rebuild DNA |
| Large audit log | Archive old entries |
| Missing checkpoint | Create fresh checkpoint |
| Missing config files | Restore from defaults |

---

## Notes

- Run `check` regularly to maintain health
- `fix` is safe - only fixes actual issues
- `reset` is destructive - requires --confirm flag
- After `reset all`, plugin reinitializes like fresh install
