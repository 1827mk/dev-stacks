#!/bin/bash
# Dev-Stacks SessionStart Hook - Compact Version

set -euo pipefail
INPUT=$(cat)
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // "unknown"')
CWD=$(echo "$INPUT" | jq -r '.cwd // "."')

DEV_STACKS_DIR="$CWD/.dev-stacks"
LOGS_DIR="$DEV_STACKS_DIR/logs"
mkdir -p "$DEV_STACKS_DIR" "$LOGS_DIR"

# Create DNA if not exists
DNA_FILE="$DEV_STACKS_DIR/dna.json"
[[ ! -f "$DNA_FILE" ]] && jq -n '{version:"1.0.0",project:{name:"",type:"unknown",languages:[],frameworks:[]},patterns:[],risk_areas:[],created:(now|strftime("%Y-%m-%dT%H:%M:%SZ"))}' > "$DNA_FILE"

# Create state file
STATE_FILE="$DEV_STACKS_DIR/state.json"
[[ ! -f "$STATE_FILE" ]] && jq -n --arg sid "$SESSION_ID" '{version:"1.0.0",session_id:$sid,current_state:"IDLE",task:null,plan:null,progress:{thinker_done:false,builder_done:false,tester_done:false},error:null}' > "$STATE_FILE"

# Create checkpoint
CHECKPOINT_FILE="$DEV_STACKS_DIR/checkpoint.json"
[[ ! -f "$CHECKPOINT_FILE" ]] && jq -n --arg sid "$SESSION_ID" '{session_id:$sid,timestamp:(now|strftime("%Y-%m-%dT%H:%M:%SZ")),state:{phase:"IDLE",current_task:null,progress:0},context:{files_touched:[],decisions_made:[],patterns_used:[]}}' > "$CHECKPOINT_FILE"

# Tool discovery (async)
PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-}"
SCAN_SCRIPT="$PLUGIN_ROOT/skills/tool-discovery/scan-tools.sh"
[[ -x "$SCAN_SCRIPT" ]] && bash "$SCAN_SCRIPT" "$CWD" > "$LOGS_DIR/tool-discovery.log" 2>&1 &

# Check DNA status
DNA_NAME=$(jq -r '.project.name // ""' "$DNA_FILE" 2>/dev/null || echo "")
DNA_WARN=""
[[ -z "$DNA_NAME" ]] && DNA_WARN=" | Run /dev-stacks:init to build DNA"

# Compact output
cat << EOF
DEV-STACKS READY
Commands: /dev-stacks:init | /dev-stacks:status | /dev-stacks:undo | /dev-stacks:learn | /dev-stacks:doctor | /dev-stacks:help
Workflow: Quick(<0.2) -> Standard(0.2-0.39) -> Careful(0.4-0.59) -> Full(>=0.6)
Agents: thinker(analyze+plan) | builder(implement) | tester(verify)
Guards: scope-guard | bash-guard | secret-scanner
DNA: $DEV_STACKS_DIR/dna.json$DNA_WARN
EOF

exit 0
