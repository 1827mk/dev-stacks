#!/usr/bin/env bash
# dev-stacks v3 — PreCompact
# Writes .dev-stacks/snapshot.md before Claude Code compresses context

set -euo pipefail

INPUT=$(cat)
CWD=$(printf '%s' "$INPUT" | jq -r '.cwd // ""')
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$CWD}"
DS_DIR="$PROJECT_DIR/.dev-stacks"

mkdir -p "$DS_DIR"

TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
GIT_BRANCH=""; GIT_SHA=""; GIT_STATUS=""
if command -v git &>/dev/null && git -C "$PROJECT_DIR" rev-parse --is-inside-work-tree &>/dev/null 2>&1; then
  GIT_BRANCH=$(git -C "$PROJECT_DIR" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")
  GIT_SHA=$(git -C "$PROJECT_DIR" rev-parse HEAD 2>/dev/null || echo "unknown")
  GIT_STATUS=$(git -C "$PROJECT_DIR" status --short 2>/dev/null | head -20 || echo "")
fi

TASK_DESC="(none)"; WORKFLOW=""; INTENT=""
STATE_FILE="$DS_DIR/state.json"
if [[ -f "$STATE_FILE" ]]; then
  TASK_DESC=$(jq -r '.task.original_prompt // "(none)"' "$STATE_FILE" 2>/dev/null || echo "(none)")
  WORKFLOW=$(jq -r '.workflow.type // ""' "$STATE_FILE" 2>/dev/null || echo "")
  INTENT=$(jq -r '.task.intent // ""' "$STATE_FILE" 2>/dev/null || echo "")
fi

cat > "$DS_DIR/snapshot.md" << SNAP
# dev-stacks snapshot — $TIMESTAMP

## Active task
Intent: $INTENT
Workflow: $WORKFLOW
Prompt: $TASK_DESC

## Git state
Branch: $GIT_BRANCH
HEAD: $GIT_SHA
Modified:
$GIT_STATUS

## On restore
1. Read this snapshot before doing anything.
2. Check git status to understand what changed.
3. If thinker had a plan, confirm with user before builder continues.
4. Do NOT re-run steps already confirmed complete.
5. If HEAD SHA has changed, run git diff <saved-SHA> HEAD before continuing.
SNAP

printf '{"continue":true}\n'
exit 0
