#!/bin/bash
# Dev-Stacks Stop Hook
# Check completion and save session state

set -euo pipefail

# Read JSON input from stdin
INPUT=$(cat)

# Extract info
CWD=$(echo "$INPUT" | jq -r '.cwd // "."')
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // "unknown"')

# Dev-Stacks directory
DEV_STACKS_DIR="$CWD/.dev-stacks"
CHECKPOINT_FILE="$DEV_STACKS_DIR/checkpoint.json"

# Update checkpoint
if [[ -f "$CHECKPOINT_FILE" ]]; then
    # Update timestamp and set to IDLE
    TMP_FILE=$(mktemp)
    jq '.state.phase = "IDLE" | .state.current_task = null | .state.progress = 100 | .timestamp = "'$(date -u +"%Y-%m-%dT%H:%M:%SZ")'"' "$CHECKPOINT_FILE" > "$TMP_FILE"
    mv "$TMP_FILE" "$CHECKPOINT_FILE"
fi

# Output brief summary
echo "📊 [DEV-STACKS] Session checkpoint saved"

exit 0
