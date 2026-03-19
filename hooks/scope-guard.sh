#!/bin/bash
# Dev-Stacks PreToolUse Scope Guard
# Protect sensitive files from modification

set -euo pipefail

# Read JSON input from stdin
INPUT=$(cat)

# Extract tool info
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // ""')
TOOL_INPUT=$(echo "$INPUT" | jq -r '.tool_input // {}')

# Get file path
FILE_PATH=$(echo "$TOOL_INPUT" | jq -r '.file_path // .path // ""')

# Normalize path (remove leading slashes)
NORMALIZED_PATH="${FILE_PATH#/}"

# Critical patterns - always block
CRITICAL_PATTERNS=(
    "^\.env"
    "\.pem$"
    "\.key$"
    "^\.git/"
    "^credentials"
    "^secrets"
    "\.secret$"
)

# High risk patterns - confirm
HIGH_PATTERNS=(
    "^package\.json$"
    "^package-lock\.json$"
    "^migrations/"
)

# Check critical patterns
for pattern in "${CRITICAL_PATTERNS[@]}"; do
    if echo "$NORMALIZED_PATH" | grep -qiE "$pattern"; then
        cat << BLOCK_MSG >&2
🛡️ Scope Guard: BLOCKED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
File: $FILE_PATH
Reason: Protected file (security sensitive)

This file is protected to prevent accidental exposure.
Please edit manually if needed.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
BLOCK_MSG
        exit 2
    fi
done

# Check high risk patterns - for now, allow but log
for pattern in "${HIGH_PATTERNS[@]}"; do
    if echo "$NORMALIZED_PATH" | grep -qiE "$pattern"; then
        # Just log, don't block
        : # No action for now
    fi
done

# Check content for secrets if Write/Edit
if [[ "$TOOL_NAME" == "Write" || "$TOOL_NAME" == "Edit" ]]; then
    CONTENT=$(echo "$TOOL_INPUT" | jq -r '.content // .new_string // ""')

    # Check for API keys, passwords, etc.
    if echo "$CONTENT" | grep -qiE '(sk-[a-zA-Z0-9]{20,}|api_key\s*=\s*["'"'"'][^"'"'"']+["'"'"']|password\s*=\s*["'"'"'][^"'"'"']+["'"'"'])'; then
        cat << SECRET_MSG >&2
🛡️ Scope Guard: SECRET DETECTED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
File: $FILE_PATH
Reason: Potential secret detected in content

Consider using environment variables instead.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
SECRET_MSG
        exit 2
    fi
fi

# Allow the tool call
exit 0
