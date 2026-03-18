---
name: PreToolUse
description: Safety guard - check tool use against guard rules before execution.
---

# PreToolUse Hook

Executed before any tool use.

## Purpose

Safety check before tool execution:
1. Log tool intent
2. Check file paths against scope guard
3. Check content for secrets
4. Check bash commands for dangerous patterns

## Execution Steps

### Step 1: Log Tool Intent

**LOG FILE (`.dev-stacks/logs/session-*.log`):**
```
[2026-03-18 10:30:14] [DEBUG] [PreToolUse] ═══════════════════════════════════════
[2026-03-18 10:30:14] [DEBUG] [PreToolUse] Tool: Edit | Intent: Modify file
[2026-03-18 10:30:14] [DEBUG]   └─ Target: src/auth/login.ts
[2026-03-18 10:30:14] [DEBUG] [PreToolUse] ═══════════════════════════════════════
```

### Step 2: Determine Guard Type

Based on tool being used:
- File tools → Scope Guard
- Write/Edit → Scope Guard + Secret Scanner
- Bash → Bash Guard

**LOG FILE:**
```
[2026-03-18 10:30:14] [DEBUG] [PreToolUse] Guard type: Scope + Secret Scanner
```

### Step 3: Run Guard Check

Check against rules from `config/protected-paths.json` and `config/dangerous-commands.json`

**LOG FILE:**
```
[2026-03-18 10:30:14] [DEBUG] [PreToolUse] Running guard checks...
[2026-03-18 10:30:14] [DEBUG]   └─ Scope Guard: PASS
[2026-03-18 10:30:14] [DEBUG]   └─ Secret Scanner: PASS
```

### Step 4: Handle Result

| Result | Action |
|--------|--------|
| PASS | Allow tool execution |
| CONFIRM | Ask user for confirmation |
| BLOCK | Prevent execution, explain why |

**LOG FILE (PASS):**
```
[2026-03-18 10:30:14] [INFO] [PreToolUse] GUARD RESULT: PASS
[2026-03-18 10:30:14] [INFO]   └─ Allowing tool execution
```

**LOG FILE (CONFIRM):**
```
[2026-03-18 10:30:14] [WARN] [PreToolUse] GUARD RESULT: CONFIRM REQUIRED
[2026-03-18 10:30:14] [WARN]   └─ File: package.json
[2026-03-18 10:30:14] [WARN]   └─ Reason: Configuration file
```

**LOG FILE (BLOCK):**
```
[2026-03-18 10:30:14] [ERROR] [PreToolUse] GUARD RESULT: BLOCKED
[2026-03-18 10:30:14] [ERROR]   └─ File: .env.production
[2026-03-18 10:30:14] [ERROR]   └─ Reason: Protected file (contains secrets)
```

## Guard Checks

### 1. Scope Guard

For file operations (Read, Write, Edit, Bash file commands):

Check path against protected patterns:

| Pattern | Action | Severity |
|---------|--------|----------|
| `.env*` | BLOCK | CRITICAL |
| `*.pem` | BLOCK | CRITICAL |
| `*.key` | BLOCK | CRITICAL |
| `.git/` | BLOCK | CRITICAL |
| `credentials*` | BLOCK | CRITICAL |
| `package.json` | CONFIRM | MEDIUM |
| `tsconfig.json` | CONFIRM | MEDIUM |
| `*.config.*` | CONFIRM | MEDIUM |

### 2. Secret Scanner

For Write, Edit operations:

Scan content for secrets:
- API keys patterns
- Password patterns
- Private key patterns
- Database connection strings

### 3. Bash Guard

For Bash tool:

Check commands for dangerous patterns:

| Pattern | Action | Severity |
|---------|--------|----------|
| `rm -rf /` | BLOCK | CRITICAL |
| `rm -rf ~` | BLOCK | CRITICAL |
| `mkfs` | BLOCK | CRITICAL |
| `dd if=` | BLOCK | CRITICAL |
| `DROP DATABASE` | BLOCK | CRITICAL |
| `DROP TABLE` | BLOCK | CRITICAL |
| `chmod 777` | CONFIRM | MEDIUM |
| `sudo` | CONFIRM | MEDIUM |

## Output Examples

### Pass (Console Silent, Log File Only)

**LOG FILE:**
```
[2026-03-18 10:30:14] [INFO] [PreToolUse] GUARD: PASS | Tool: Edit | File: src/auth/login.ts
```

**CONSOLE:** (no output - tool executes normally)

### Confirm Required

**CONSOLE:**
```
🛡️ Guard: CONFIRMATION REQUIRED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
File: package.json
Reason: Configuration file - changes may affect project dependencies

Proceed with this change? [Y/n]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**LOG FILE:**
```
[2026-03-18 10:30:14] [WARN] [PreToolUse] ═══════════════════════════════════════
[2026-03-18 10:30:14] [WARN] [PreToolUse] GUARD: CONFIRMATION REQUIRED
[2026-03-18 10:30:14] [WARN]   └─ File: package.json
[2026-03-18 10:30:14] [WARN]   └─ Reason: Configuration file
[2026-03-18 10:30:14] [WARN]   └─ Severity: MEDIUM
[2026-03-18 10:30:14] [WARN] [PreToolUse] ═══════════════════════════════════════
[2026-03-18 10:30:15] [INFO] [PreToolUse] User response: Y (proceeding)
```

### Blocked

**CONSOLE:**
```
🛡️ Guard: BLOCKED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
File: .env.production
Reason: Protected file (contains secrets)

This file type is protected to prevent accidental exposure.
Please edit manually or use --override to bypass (not recommended).
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**LOG FILE:**
```
[2026-03-18 10:30:14] [ERROR] [PreToolUse] ═══════════════════════════════════════
[2026-03-18 10:30:14] [ERROR] [PreToolUse] GUARD: BLOCKED
[2026-03-18 10:30:14] [ERROR]   └─ File: .env.production
[2026-03-18 10:30:14] [ERROR]   └─ Reason: Protected file (contains secrets)
[2026-03-18 10:30:14] [ERROR]   └─ Severity: CRITICAL
[2026-03-18 10:30:14] [ERROR] [PreToolUse] ═══════════════════════════════════════
```

### Secret Detected

**CONSOLE:**
```
🛡️ Guard: SECRET DETECTED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Pattern: API key found in code
File: src/config/api.ts
Line: 42

Found: api_key = "sk-abc123..."
Reason: Hardcoded secrets are a security risk

Suggestions:
1. Use environment variable: process.env.API_KEY
2. Store in .env file (already protected)
3. Use secrets manager

Proceed anyway? [y/N]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**LOG FILE:**
```
[2026-03-18 10:30:14] [ERROR] [PreToolUse] ═══════════════════════════════════════
[2026-03-18 10:30:14] [ERROR] [PreToolUse] GUARD: SECRET DETECTED
[2026-03-18 10:30:14] [ERROR]   └─ File: src/config/api.ts
[2026-03-18 10:30:14] [ERROR]   └─ Line: 42
[2026-03-18 10:30:14] [ERROR]   └─ Pattern: API key
[2026-03-18 10:30:14] [ERROR] [PreToolUse] ═══════════════════════════════════════
[2026-03-18 10:30:15] [INFO] [PreToolUse] User response: n (blocked)
```

### Dangerous Command Blocked

**CONSOLE:**
```
🛡️ Guard: DANGEROUS COMMAND BLOCKED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Command: rm -rf node_modules
Reason: Destructive command

This command could result in data loss.
If intentional, please run manually in terminal.

Alternative: Use with specific path: rm -rf ./node_modules
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**LOG FILE:**
```
[2026-03-18 10:30:14] [ERROR] [PreToolUse] ═══════════════════════════════════════
[2026-03-18 10:30:14] [ERROR] [PreToolUse] GUARD: DANGEROUS COMMAND BLOCKED
[2026-03-18 10:30:14] [ERROR]   └─ Command: rm -rf node_modules
[2026-03-18 10:30:14] [ERROR]   └─ Reason: Destructive command
[2026-03-18 10:30:14] [ERROR]   └─ Severity: CRITICAL
[2026-03-18 10:30:14] [ERROR] [PreToolUse] ═══════════════════════════════════════
```

## MCP Tools Used

| Tool | Purpose |
|------|---------|
| `mcp__filesystem__read_text_file` | Read guard config |

## Notes

- **LOG ALL GUARD CHECKS** to session log file
- Guards are safety nets, not blockers
- Users can always override if needed
- All blocks are logged to audit trail
- Guard rules are configurable in config/
- Console output only on CONFIRM or BLOCK
