#!/usr/bin/env bash
# dev-stacks v3 — SessionStart hook
# Output: hookSpecificOutput.additionalContext (verified from official docs)
# Uses python3 for JSON parsing (no jq dependency)

set -euo pipefail

INPUT=$(cat)
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-}"
if [[ -z "$PROJECT_DIR" ]]; then
  PROJECT_DIR=$(printf '%s' "$INPUT" | python3 -c "import json,sys; print(json.load(sys.stdin).get('cwd',''))" 2>/dev/null || echo "")
fi

SESSION_ID=$(printf '%s' "$INPUT" | python3 -c "import json,sys; print(json.load(sys.stdin).get('session_id','unknown'))" 2>/dev/null || echo "unknown")
DS_DIR="$PROJECT_DIR/.dev-stacks"
SNAPSHOT="$DS_DIR/snapshot.md"
DNA="$DS_DIR/dna.json"

mkdir -p "$DS_DIR/logs"

# Build context lines
LINES=()
LINES+=("=== dev-stacks session: $SESSION_ID ===")

# DNA summary
if [[ -f "$DNA" ]]; then
  NAME=$(python3 -c "import json; d=json.load(open('$DNA')); print(d.get('project',{}).get('name','?'))" 2>/dev/null || echo "?")
  LANGS=$(python3 -c "import json; d=json.load(open('$DNA')); print(', '.join(d.get('project',{}).get('languages',[])))" 2>/dev/null || echo "")
  RISKS=$(python3 -c "import json; d=json.load(open('$DNA')); print(', '.join(d.get('risk_areas',[])))" 2>/dev/null || echo "none")
  LINES+=("project: $NAME | stack: $LANGS | risks: $RISKS")
else
  LINES+=("DNA not found — run /dev-stacks:registry to initialise")
fi

# Snapshot
if [[ -f "$SNAPSHOT" ]]; then
  LINES+=("")
  LINES+=("--- ACTIVE TASK SNAPSHOT ---")
  while IFS= read -r line; do
    LINES+=("$line")
  done < "$SNAPSHOT"
  LINES+=("--- END SNAPSHOT ---")
  LINES+=("⚠️ Read snapshot above before doing anything.")
else
  LINES+=("commands: /dev-stacks:agents  /dev-stacks:plan  /dev-stacks:tasks  /dev-stacks:status  /dev-stacks:registry")
fi

# Join lines
CONTEXT=$(printf '%s\n' "${LINES[@]}")

# Escape for JSON using python3
ESCAPED=$(python3 -c "
import json, sys
text = sys.stdin.read()
# json.dumps wraps in quotes and escapes — strip the outer quotes
print(json.dumps(text)[1:-1])
" <<< "$CONTEXT")

printf '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"%s"}}\n' "$ESCAPED"
exit 0
