#!/bin/bash
# Dev-Stacks SessionStart Hook
# Initialize Dev-Stacks environment when session starts

set -euo pipefail

# Read JSON input from stdin
INPUT=$(cat)

# Extract session info
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // "unknown"')
CWD=$(echo "$INPUT" | jq -r '.cwd // "."')

# Dev-Stacks directory
DEV_STACKS_DIR="$CWD/.dev-stacks"
LOGS_DIR="$DEV_STACKS_DIR/logs"

# Create directory structure if not exists
mkdir -p "$DEV_STACKS_DIR"
mkdir -p "$LOGS_DIR"

# Create initial DNA if not exists
DNA_FILE="$DEV_STACKS_DIR/dna.json"
if [[ ! -f "$DNA_FILE" ]]; then
    TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    jq -n \
        --arg ts "$TIMESTAMP" \
        '{
            version: "1.0.0",
            project: {
                name: "",
                type: "unknown",
                languages: [],
                frameworks: []
            },
            patterns: [],
            risk_areas: [],
            created: $ts
        }' > "$DNA_FILE"
fi

# Create checkpoint if not exists
CHECKPOINT_FILE="$DEV_STACKS_DIR/checkpoint.json"
if [[ ! -f "$CHECKPOINT_FILE" ]]; then
    TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    jq -n \
        --arg sid "$SESSION_ID" \
        --arg ts "$TIMESTAMP" \
        '{
            session_id: $sid,
            timestamp: $ts,
            state: {
                phase: "IDLE",
                current_task: null,
                progress: 0
            },
            context: {
                files_touched: [],
                decisions_made: [],
                patterns_used: []
            }
        }' > "$CHECKPOINT_FILE"
fi

# Create session log
SESSION_LOG="$LOGS_DIR/session-$(date +"%Y-%m-%d-%H%M%S").log"
touch "$SESSION_LOG"

# Output welcome message (stdout is added as context for SessionStart)
cat << 'EOF'
🚀 DEV-STACKS INITIALIZED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Dev-Stacks is ready to assist you.

Features available:
• Intent routing (Thai/English/Mixed)
• Adaptive workflows (Quick/Standard/Careful/Full)
• Agent teams (Thinker, Builder, Tester)
• Pattern learning
• Safety guards

Commands:
  /dev-stacks:status   - View system status
  /dev-stacks:undo     - Undo changes
  /dev-stacks:learn    - Manage patterns
  /dev-stacks:doctor   - Diagnose issues
  /dev-stacks:help     - Show help

Just describe what you need in natural language.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

exit 0
