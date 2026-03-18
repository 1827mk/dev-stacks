---
name: bash-guard
description: Prevent dangerous bash commands from execution. Use before Bash tool.
---

# Bash Guard

Prevents dangerous bash commands from being executed.

## Purpose

Check bash commands against dangerous patterns before execution.

## Dangerous Commands

### CRITICAL (Always Block)

| Pattern | Reason |
|---------|--------|
| `rm -rf /` | Destroys entire filesystem |
| `rm -rf /*` | Destroys entire filesystem |
| `rm -rf ~` | Destroys home directory |
| `mkfs` | Formats filesystem |
| `dd if=` | Disk operations |
| `:(){ :\|:& };:` | Fork bomb |
| `> /dev/sda` | Direct disk write |

### HIGH (Block with Override)

| Pattern | Reason |
|---------|--------|
| `DROP DATABASE` | Destructive SQL |
| `DROP TABLE` | Destructive SQL |
| `TRUNCATE` | Destructive SQL |
| `rm -rf` (root paths) | Recursive deletion |

### MEDIUM (Confirm Required)

| Pattern | Reason |
|---------|--------|
| `chmod -R 777` | Insecure permissions |
| `sudo` | Privileged execution |
| `curl \| bash` | Remote code execution |
| `wget \| bash` | Remote code execution |
| `eval` | Dynamic code execution |

## Process

### Step 1: Receive Command

Get the bash command being executed.

### Step 2: Check Against Patterns

Match against dangerous commands from `config/dangerous-commands.json`.

### Step 3: Determine Action

| Match | Action |
|-------|--------|
| CRITICAL | BLOCK - Never allow |
| HIGH | BLOCK - Show warning |
| MEDIUM | CONFIRM - Ask user |
| No match | ALLOW - Proceed |

## Output Format

### BLOCK (CRITICAL)
```
🛡️ Bash Guard: BLOCKED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Command: [command]
Pattern: [matched pattern]
Severity: CRITICAL
Reason: [explanation]

This command is blocked for safety reasons.
If you need to run this, please execute manually in terminal.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### CONFIRM (MEDIUM)
```
🛡️ Bash Guard: CONFIRMATION REQUIRED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Command: [command]
Pattern: [matched pattern]
Severity: MEDIUM
Reason: [explanation]

This command requires elevated permissions or has security implications.
Proceed? [Y/n]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### ALLOW
```
(no output - command executes)
```

## Examples

### Example 1: Blocked
```
Command: rm -rf /

🛡️ Bash Guard: BLOCKED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Command: rm -rf /
Pattern: rm -rf /
Severity: CRITICAL
Reason: This command would destroy the entire filesystem

This command is blocked for safety reasons.
If you need to run this, please execute manually in terminal.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Example 2: Confirm
```
Command: sudo npm install -g package

🛡️ Bash Guard: CONFIRMATION REQUIRED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Command: sudo npm install -g package
Pattern: sudo
Severity: MEDIUM
Reason: sudo executes with elevated privileges

This command requires elevated permissions or has security implications.
Proceed? [Y/n]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Example 3: Safe Command
```
Command: npm run test

(no output - command executes)
```

## Safe Patterns

These patterns are NOT flagged:
- `npm run *` - npm scripts
- `git status` - git information
- `ls` - directory listing
- `cat [file]` - file reading
- `node [script]` - running Node scripts

## Usage

Automatically invoked by PreToolUse hook before Bash tool.
