#!/bin/bash
# Dev-Stacks Bash Guard
# Block dangerous bash commands

set -euo pipefail

# Read JSON input from stdin
INPUT=$(cat)

# Extract command
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // ""')

# Critical patterns - always block
CRITICAL_PATTERNS=(
    "^rm -rf /"
    "^rm -rf /*"
    "^rm -rf ~"
    "^mkfs"
    "^dd if="
    "DROP DATABASE"
    "DROP TABLE"
)

# High risk patterns - block with warning
HIGH_PATTERNS=(
    "TRUNCATE"
    "DELETE FROM"
)

# Medium risk patterns - warn but allow
MEDIUM_PATTERNS=(
    "chmod -R 777"
    "^sudo"
    "curl | bash"
    "wget | bash"
)

# Check critical patterns
for pattern in "${CRITICAL_PATTERNS[@]}"; do
    if echo "$COMMAND" | grep -qiE "$pattern"; then
        cat << BLOCK_MSG >&2
🛡️ Bash Guard: BLOCKED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Command: $COMMAND
Pattern: $pattern
Reason: Critical - This command is too dangerous to execute

This command is blocked for safety reasons.
If you need to run this, please execute manually in terminal.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
BLOCK_MSG
        exit 2
    fi
done

# Check high risk patterns
for pattern in "${HIGH_PATTERNS[@]}"; do
    if echo "$COMMAND" | grep -qi "$pattern"; then
        cat << WARN_MSG >&2
🛡️ Bash Guard: WARNING
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Command: $COMMAND
Pattern: $pattern
Reason: High risk - This command may cause data loss

Please confirm this is intentional.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
WARN_MSG
        exit 2
    fi
done

# Check medium risk patterns - warn but don't block
for pattern in "${MEDIUM_PATTERNS[@]}"; do
    if echo "$COMMAND" | grep -qiE "$pattern"; then
        cat << MEDIUM_MSG
⚠️ Bash Guard: CAUTION
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Command: $COMMAND
Pattern: $pattern
Reason: Medium risk - Proceed with caution

This command is allowed but requires care.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
MEDIUM_MSG
        # Don't exit, just warn
        break
    fi
done

# Allow command
exit 0
