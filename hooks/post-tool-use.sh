#!/bin/bash
# Dev-Stacks PostToolUse Hook
# Log tool usage and track files

set -euo pipefail

# Read JSON input from stdin
INPUT=$(cat)

# Extract info
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // ""')
TOOL_INPUT=$(echo "$INPUT" | jq -r '.tool_input // {}')
CWD=$(echo "$INPUT" | jq -r '.cwd // "."')

# Get file path for file operations
FILE_PATH=""
if echo "$TOOL_NAME" | grep -qiE "Write|Edit|MultiEdit"; then
    FILE_PATH=$(echo "$TOOL_INPUT" | jq -r '.file_path // .path // ""')
fi

# Dev-Stacks directory
DEV_STACKS_DIR="$CWD/.dev-stacks"
LOGS_DIR="$DEV_STACKS_DIR/logs"
AUDIT_FILE="$LOGS_DIR/audit.jsonl"

# Ensure directories exist
mkdir -p "$LOGS_DIR"

# Create audit entry
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // "unknown"')

AUDIT_ENTRY=$(cat << ENTRY
{"timestamp":"$TIMESTAMP","session_id":"$SESSION_ID","tool":"$TOOL_NAME","file":"$FILE_PATH","success":true}
ENTRY
)

# Append to audit log
echo "$AUDIT_ENTRY" >> "$AUDIT_FILE"

# Log to console (brief)
if [[ -n "$FILE_PATH" ]]; then
    echo "📝 [DEV-STACKS] Tool: $TOOL_NAME | File: $FILE_PATH | Status: ✅"
fi

exit 0
