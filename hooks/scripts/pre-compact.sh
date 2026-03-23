#!/usr/bin/env bash
# dev-stacks v4 — PreCompact
# Saves working state before context compression
# Output: {} (verified from official docs)

set -uo pipefail

INPUT=$(cat)
CWD=$(printf '%s' "$INPUT" | python3 -c "import json,sys; print(json.load(sys.stdin).get('cwd',''))" 2>/dev/null || echo "")
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$CWD}"
DS_DIR="$PROJECT_DIR/.dev-stacks"
mkdir -p "$DS_DIR"

TS=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
BRANCH="unknown"; SHA="unknown"; STATUS=""
if command -v git &>/dev/null && git -C "$PROJECT_DIR" rev-parse --is-inside-work-tree &>/dev/null 2>&1; then
  BRANCH=$(git -C "$PROJECT_DIR" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")
  SHA=$(git -C "$PROJECT_DIR" rev-parse HEAD 2>/dev/null || echo "unknown")
  STATUS=$(git -C "$PROJECT_DIR" status --short 2>/dev/null | head -20 || echo "")
fi

TASK="(none)"; PHASE=""; INTENT=""
STATE="$DS_DIR/state.json"
if [[ -f "$STATE" ]]; then
  TASK=$(python3 -c "import json; d=json.load(open('$STATE')); print(d.get('task',{}).get('prompt','(none)'))" 2>/dev/null || echo "(none)")
  PHASE=$(python3 -c "import json; d=json.load(open('$STATE')); print(d.get('phase',''))" 2>/dev/null || echo "")
  INTENT=$(python3 -c "import json; d=json.load(open('$STATE')); print(d.get('intent',''))" 2>/dev/null || echo "")
fi

cat > "$DS_DIR/snapshot.md" << SNAP
# dev-stacks snapshot — $TS

## Task
Intent: $INTENT | Phase: $PHASE
Prompt: $TASK

## Git
Branch: $BRANCH | HEAD: $SHA
Modified:
$STATUS

## On restore
1. Read this snapshot first.
2. Confirm with user before continuing any incomplete step.
3. Do NOT redo completed steps.
4. If HEAD changed: git diff $SHA HEAD
SNAP

printf '{}\n'
exit 0
