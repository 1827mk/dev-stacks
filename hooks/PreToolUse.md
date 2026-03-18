---
name: PreToolUse
description: Safety guard - check tool use against guard rules before execution.
---

# PreToolUse Hook

Executed before any tool use.

## Purpose

Safety check before tool execution:
1. Check file paths against scope guard
2. Check content for secrets
3. Check bash commands for dangerous patterns

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

## Execution Steps

### Step 1: Determine Guard Type

Based on tool being used:
- File tools → Scope Guard
- Write/Edit → Scope Guard + Secret Scanner
- Bash → Bash Guard

### Step 2: Run Guard Check

Check against rules from `config/protected-paths.json` and `config/dangerous-commands.json`

### Step 3: Handle Result

| Result | Action |
|--------|--------|
| PASS | Allow tool execution |
| CONFIRM | Ask user for confirmation |
| BLOCK | Prevent execution, explain why |

## Output Examples

### Pass
```
(no output - tool executes normally)
```

### Confirm Required
```
🛡️ Guard: CONFIRMATION REQUIRED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
File: package.json
Reason: Configuration file - changes may affect project dependencies

Proceed with this change? [Y/n]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Blocked
```
🛡️ Guard: BLOCKED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
File: .env.production
Reason: Protected file (contains secrets)

This file type is protected to prevent accidental exposure.
Please edit manually or use --override to bypass (not recommended).
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Secret Detected
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

### Dangerous Command Blocked
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

## MCP Tools Used

| Tool | Purpose |
|------|---------|
| `mcp__filesystem__read_text_file` | Read guard config |

## Notes

- Guards are safety nets, not blockers
- Users can always override if needed
- All blocks are logged to audit trail
- Guard rules are configurable in config/
