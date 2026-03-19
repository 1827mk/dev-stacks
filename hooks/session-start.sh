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

# Create state file for orchestrator if not exists
STATE_FILE="$DEV_STACKS_DIR/state.json"
if [[ ! -f "$STATE_FILE" ]]; then
    TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    jq -n \
        --arg sid "$SESSION_ID" \
        --arg ts "$TIMESTAMP" \
        '{
            version: "1.0.0",
            session_id: $sid,
            current_state: "IDLE",
            task: null,
            plan: null,
            progress: {
                thinker_done: false,
                builder_done: false,
                tester_done: false
            },
            error: null,
            timestamps: {
                created: $ts,
                last_updated: $ts
            }
        }' > "$STATE_FILE"
fi

# Create session log with initial content
SESSION_LOG="$LOGS_DIR/session-$(date +"%Y-%m-%d-%H%M%S").log"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
cat > "$SESSION_LOG" << LOGHEADER
# Dev-Stacks Session Log
# Session ID: $SESSION_ID
# Started: $TIMESTAMP
# Working Directory: $CWD
# ========================================
LOGHEADER

# Run Tool Discovery scan (async, non-blocking)
# Find scan script from plugin cache or project directory
PLUGIN_CACHE="${CLAUDE_PLUGIN_ROOT:-}"
SCAN_SCRIPT_CACHE="$PLUGIN_CACHE/skills/tool-discovery/scan-tools.sh"
SCAN_SCRIPT_LOCAL="$CWD/skills/tool-discovery/scan-tools.sh"

if [[ -x "$SCAN_SCRIPT_CACHE" ]]; then
    # Run from plugin cache, but pass project path as argument
    bash "$SCAN_SCRIPT_CACHE" "$CWD" > "$LOGS_DIR/tool-discovery.log" 2>&1 &
    TOOL_DISCOVERY="✓ Tool registry updated"
elif [[ -x "$SCAN_SCRIPT_LOCAL" ]]; then
    # Run from project directory
    bash "$SCAN_SCRIPT_LOCAL" "$CWD" > "$LOGS_DIR/tool-discovery.log" 2>&1 &
    TOOL_DISCOVERY="✓ Tool registry updated"
else
    TOOL_DISCOVERY="⚠ Tool discovery not available"
fi

# Check if DNA needs initialization
DNA_NAME=$(jq -r '.identity.name // .project.name // ""' "$DNA_FILE" 2>/dev/null || echo "")
NEEDS_INIT=""
if [[ -z "$DNA_NAME" || "$DNA_NAME" == "" ]]; then
    NEEDS_INIT="
⚠️ DNA not initialized. Run /dev-stacks:init to build project DNA.
"
fi

# Output welcome message (stdout is added as context for SessionStart)
cat << EOF
🚀 DEV-STACKS INITIALIZED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Dev-Stacks is ready to assist you.

Features available:
• Intent routing (Thai/English/Mixed)
• Adaptive workflows (Quick/Standard/Careful/Full)
• Agent teams (Thinker, Builder, Tester)
• Pattern learning
• Safety guards
• Tool discovery & recommendation
• Quality gates

Commands:
  /dev-stacks:init     - Initialize/update project DNA
  /dev-stacks:status   - View system status
  /dev-stacks:undo     - Undo changes
  /dev-stacks:learn    - Manage patterns
  /dev-stacks:doctor   - Diagnose issues
  /dev-stacks:help     - Show help
$NEEDS_INIT
Just describe what you need in natural language.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

exit 0
