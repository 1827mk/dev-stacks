#!/usr/bin/env bash
# dev-stacks v3 — SessionStart
# Injects snapshot context via hookSpecificOutput.additionalContext (correct Claude Code format)

set -euo pipefail

INPUT=$(cat)
CWD=$(printf '%s' "$INPUT" | jq -r '.cwd // ""')
SESSION_ID=$(printf '%s' "$INPUT" | jq -r '.session_id // "unknown"')

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$CWD}"
DS_DIR="$PROJECT_DIR/.dev-stacks"
SNAPSHOT="$DS_DIR/snapshot.md"

mkdir -p "$DS_DIR/logs"

if [[ -f "$SNAPSHOT" ]]; then
  INJECT="<dev-stack-context>
SESSION: $SESSION_ID | PROJECT: $PROJECT_DIR

$(cat "$SNAPSHOT")

⚠️  This snapshot was preserved before context compaction.
Read it to restore working state before proceeding.
</dev-stack-context>"
else
  INJECT="<dev-stack-context>
SESSION: $SESSION_ID | PROJECT: $PROJECT_DIR
No snapshot found — fresh session.
Run /dev-stacks:init to build project DNA.
Commands: /dev-stacks:run  /dev-stacks:init  /dev-stacks:checkpoint  /dev-stacks:review  /dev-stacks:status
</dev-stack-context>"
fi

escape_json() {
  local s="$1"
  s="${s//\\/\\\\}"; s="${s//\"/\\\"}"; s="${s//$'\n'/\\n}"
  s="${s//$'\r'/\\r}"; s="${s//$'\t'/\\t}"
  printf '%s' "$s"
}

ESCAPED=$(escape_json "$INJECT")
printf '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"%s"}}\n' "$ESCAPED"
exit 0
