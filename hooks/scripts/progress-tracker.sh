#!/usr/bin/env bash
# dev-stacks v4 — Progress Tracker (SubagentStart/SubagentStop)
# Outputs status bar to stderr, never blocks

set -uo pipefail
INPUT=$(cat)

# Extract event type and agent info
EVENT=$(printf '%s' "$INPUT" | python3 -c "import json,sys; print(json.load(sys.stdin).get('hook_event_name',''))" 2>/dev/null || echo "")
AGENT=$(printf '%s' "$INPUT" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d.get('agent_name',d.get('subagent_name','')))" 2>/dev/null || echo "")

# Progress state file
PROGRESS_FILE="${CLAUDE_PROJECT_ROOT:-.}/.dev-stacks/progress.json"

# Agent order for progress
AGENTS=("scout" "architect" "builder" "verifier" "sentinel" "chronicler")

get_phase() {
  case "$1" in
    scout|architect) echo "1" ;;
    builder) echo "2" ;;
    verifier|sentinel) echo "3" ;;
    chronicler) echo "4" ;;
    *) echo "?" ;;
  esac
}

calculate_progress() {
  local current="$1"
  local found=0
  local total=${#AGENTS[@]}
  local completed=0

  for agent in "${AGENTS[@]}"; do
    if [[ "$agent" == "$current" ]]; then
      found=1
    elif [[ $found -eq 0 ]]; then
      ((completed++))
    fi
  done

  # Add 0.5 if we're in the middle of current agent
  local progress=$((completed * 10))
  echo $progress
}

# Determine current agent from event
CURRENT_AGENT=""
case "$EVENT" in
  SubagentStart)
    CURRENT_AGENT="$AGENT"
    ACTION="→"
    ;;
  SubagentStop)
    CURRENT_AGENT="$AGENT"
    ACTION="✓"
    ;;
esac

if [[ -n "$CURRENT_AGENT" ]]; then
  PROGRESS=$(calculate_progress "$CURRENT_AGENT")
  PHASE=$(get_phase "$CURRENT_AGENT")

  # Build progress bar (10 blocks)
  FILLED=$((PROGRESS / 10))
  EMPTY=$((10 - FILLED))
  BAR=$(printf '█%.0s' $(seq 1 $FILLED 2>/dev/null))$(printf '░%.0s' $(seq 1 $EMPTY 2>/dev/null))

  # Output status bar to stderr
  printf '[dev-stacks] PHASE %s %s %d%% %s %s\n' \
    "$PHASE" "$BAR" "$PROGRESS" "$ACTION" "$CURRENT_AGENT" >&2
fi

exit 0
