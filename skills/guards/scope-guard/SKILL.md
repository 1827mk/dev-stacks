---
name: scope-guard
description: Protect sensitive files from modification. Auto-invoked before Write/Edit.
---

# Scope Guard

Protect sensitive files from unauthorized modification.

## Protected Paths

| Severity | Patterns |
|----------|----------|
| CRITICAL | `.env*`, `*.pem`, `*.key`, `.git/`, `credentials*`, `secrets*` |
| HIGH | `package.json`, `package-lock.json`, `migrations/` |
| MEDIUM | `tsconfig.json`, `*.config.*`, `.github/` |

## Actions

| Severity | Action |
|----------|--------|
| CRITICAL | BLOCK - Never allow |
| HIGH | CONFIRM - Ask user |
| MEDIUM | CONFIRM - Ask user |
| No match | ALLOW |

## Output

### BLOCK
```
Scope Guard: BLOCKED
File: [path]
Reason: [why]
Edit manually if needed.
```

### CONFIRM
```
Scope Guard: CONFIRM
File: [path]
Reason: [why]
Proceed? [Y/n]
```

## Usage
Auto-invoked by PreToolUse hook before Write/Edit tools.
