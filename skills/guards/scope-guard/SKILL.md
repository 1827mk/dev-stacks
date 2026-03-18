---
name: scope-guard
description: Protect sensitive files and paths from modification. Use before any file operation.
---

# Scope Guard

Protects sensitive files and paths from unauthorized modification.

## Purpose

Check file paths against protected patterns before allowing modifications.

## Protected Paths

### CRITICAL (Always Block)

| Pattern | Reason |
|---------|--------|
| `.env*` | Environment secrets |
| `*.pem` | Certificates |
| `*.key` | Private keys |
| `.git/` | Version control |
| `credentials*` | Credentials files |
| `secrets*` | Secrets files |
| `*.secret` | Secret files |

### HIGH (Confirm Required)

| Pattern | Reason |
|---------|--------|
| `package.json` | Dependencies |
| `package-lock.json` | Lock file |
| `migrations/` | Database migrations |

### MEDIUM (Confirm Required)

| Pattern | Reason |
|---------|--------|
| `tsconfig.json` | TypeScript config |
| `*.config.*` | Configuration files |
| `.github/` | CI/CD workflows |

## Process

### Step 1: Receive Path

Get the file path being accessed.

### Step 2: Check Against Patterns

Match against protected paths from `config/protected-paths.json`.

### Step 3: Determine Action

| Match | Action |
|-------|--------|
| CRITICAL | BLOCK - Never allow |
| HIGH | CONFIRM - Ask user |
| MEDIUM | CONFIRM - Ask user |
| No match | ALLOW - Proceed |

## Output Format

### BLOCK
```
🛡️ Scope Guard: BLOCKED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
File: [path]
Pattern: [matched pattern]
Severity: CRITICAL
Reason: [explanation]

This file is protected and cannot be modified by Dev-Stacks.
Please edit manually if needed.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### CONFIRM
```
🛡️ Scope Guard: CONFIRMATION REQUIRED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
File: [path]
Pattern: [matched pattern]
Severity: [HIGH/MEDIUM]
Reason: [explanation]

This file may affect project configuration.
Proceed with modification? [Y/n]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### ALLOW
```
(no output - operation proceeds)
```

## Examples

### Example 1: Blocked
```
Path: .env.production

🛡️ Scope Guard: BLOCKED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
File: .env.production
Pattern: .env*
Severity: CRITICAL
Reason: Environment files contain secrets

This file is protected and cannot be modified by Dev-Stacks.
Please edit manually if needed.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Example 2: Confirm
```
Path: package.json

🛡️ Scope Guard: CONFIRMATION REQUIRED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
File: package.json
Pattern: package.json
Severity: HIGH
Reason: Package configuration affects dependencies

This file may affect project configuration.
Proceed with modification? [Y/n]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Usage

Automatically invoked by PreToolUse hook before file operations.
