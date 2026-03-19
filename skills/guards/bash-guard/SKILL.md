---
name: bash-guard
description: Block dangerous bash commands. Auto-invoked before Bash tool.
---

# Bash Guard

Block dangerous commands before execution.

## Dangerous Commands

| Severity | Patterns |
|----------|----------|
| CRITICAL | `rm -rf /`, `rm -rf /*`, `rm -rf ~`, `mkfs`, `dd if=`, `:(){ :|:& };:`, `> /dev/sda` |
| HIGH | `DROP DATABASE`, `DROP TABLE`, `TRUNCATE`, `rm -rf` (root) |
| MEDIUM | `chmod -R 777`, `sudo`, `curl | bash`, `wget | bash`, `eval` |

## Actions

| Severity | Action |
|----------|--------|
| CRITICAL | BLOCK - Never allow |
| HIGH | BLOCK - Show warning |
| MEDIUM | CONFIRM - Ask user |
| No match | ALLOW |

## Output

### BLOCK
```
Bash Guard: BLOCKED
Command: [cmd]
Reason: [why]
Execute manually if needed.
```

### CONFIRM
```
Bash Guard: CONFIRM
Command: [cmd]
Reason: [why]
Proceed? [Y/n]
```

## Safe Commands
- `npm run *`
- `git status`
- `ls`, `cat`, `node`

## Usage
Auto-invoked by PreToolUse hook before Bash tool.
