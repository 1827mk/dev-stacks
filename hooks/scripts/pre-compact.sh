#!/usr/bin/env bash
# dev-stacks v3 — PreCompact hook
# Saves snapshot before context compression
# Output: {} (verified from official docs — PreCompact uses empty JSON)

set -euo pipefail

INPUT=$(cat)
CWD=$(printf '%s' "$INPUT" | python3 -c "import json,sys; print(json.load(sys.stdin).get('cwd',''))" 2>/dev/null || echo "")
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$CWD}"
DS_DIR="$PROJECT_DIR/.dev-stacks"

mkdir -p "$DS_DIR"

TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Git state
GIT_BRANCH="unknown"; GIT_SHA="unknown"; GIT_STATUS=""
if command -v git &>/dev/null && git -C "$PROJECT_DIR" rev-parse --is-inside-work-tree &>/dev/null 2>&1; then
  GIT_BRANCH=$(git -C "$PROJECT_DIR" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")
  GIT_SHA=$(git -C "$PROJECT_DIR" rev-parse HEAD 2>/dev/null || echo "unknown")
  GIT_STATUS=$(git -C "$PROJECT_DIR" status --short 2>/dev/null | head -20 || echo "")
fi

# State
TASK="(none)"; WORKFLOW=""; INTENT=""; PHASE=""
STATE="$DS_DIR/state.json"
if [[ -f "$STATE" ]]; then
  TASK=$(python3 -c "import json; d=json.load(open('$STATE')); print(d.get('task',{}).get('original_prompt','(none)'))" 2>/dev/null || echo "(none)")
  WORKFLOW=$(python3 -c "import json; d=json.load(open('$STATE')); print(d.get('workflow',{}).get('type',''))" 2>/dev/null || echo "")
  INTENT=$(python3 -c "import json; d=json.load(open('$STATE')); print(d.get('task',{}).get('intent',''))" 2>/dev/null || echo "")
  PHASE=$(python3 -c "import json; d=json.load(open('$STATE')); print(d.get('workflow',{}).get('current_phase',''))" 2>/dev/null || echo "")
fi

cat > "$DS_DIR/snapshot.md" << SNAP
# dev-stacks snapshot — $TIMESTAMP

## Active task
Intent: $INTENT | Workflow: $WORKFLOW | Phase: $PHASE
Prompt: $TASK

## Git state
Branch: $GIT_BRANCH
HEAD: $GIT_SHA
Modified:
$GIT_STATUS

## On restore
1. Read this snapshot before anything else.
2. Check git diff to understand what changed.
3. Confirm with user before continuing any incomplete steps.
4. Do NOT re-run completed steps.
SNAP

# VERIFIED: PreCompact output is empty JSON
printf '{}\n'
exit 0
