#!/usr/bin/env bash
# dev-stacks v3 — SubagentStart hook
# Injects DNA + registry context into every subagent when spawned
# Output: hookSpecificOutput.additionalContext (per official docs)

set -euo pipefail

INPUT=$(cat)
CWD=$(printf '%s' "$INPUT" | python3 -c "import json,sys; print(json.load(sys.stdin).get('cwd',''))" 2>/dev/null || echo "")
AGENT_TYPE=$(printf '%s' "$INPUT" | python3 -c "import json,sys; print(json.load(sys.stdin).get('agent_type','unknown'))" 2>/dev/null || echo "unknown")

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$CWD}"
DS_DIR="$PROJECT_DIR/.dev-stacks"
DNA="$DS_DIR/dna.json"

LINES=()
LINES+=("[dev-stacks] subagent: $AGENT_TYPE")

# Inject DNA summary if available
if [[ -f "$DNA" ]]; then
  NAME=$(python3 -c "import json; d=json.load(open('$DNA')); print(d.get('project',{}).get('name','?'))" 2>/dev/null || echo "?")
  LANGS=$(python3 -c "import json; d=json.load(open('$DNA')); print(', '.join(d.get('project',{}).get('languages',[])))" 2>/dev/null || echo "")
  RISKS=$(python3 -c "import json; d=json.load(open('$DNA')); print(', '.join(d.get('risk_areas',[])))" 2>/dev/null || echo "none")
  AUTH=$(python3 -c "import json; d=json.load(open('$DNA')); print(d.get('critical_paths',{}).get('auth','unknown'))" 2>/dev/null || echo "unknown")
  DATA=$(python3 -c "import json; d=json.load(open('$DNA')); print(d.get('critical_paths',{}).get('data_access','unknown'))" 2>/dev/null || echo "unknown")

  LINES+=("project: $NAME | stack: $LANGS")
  LINES+=("risk areas: $RISKS")
  LINES+=("auth path: $AUTH")
  LINES+=("data access: $DATA")
fi

LINES+=("")
LINES+=("Core rules:")
LINES+=("- Read file before writing — always use serena read_file first")
LINES+=("- Ask user before web search — never search without permission")
LINES+=("- Ask when unsure — never guess or invent content")
LINES+=("- Never run git add or stage files")

CONTEXT=$(printf '%s\n' "${LINES[@]}")

ESCAPED=$(python3 -c "
import json, sys
print(json.dumps(sys.stdin.read())[1:-1])
" <<< "$CONTEXT")

printf '{"hookSpecificOutput":{"hookEventName":"SubagentStart","additionalContext":"%s"}}\n' "$ESCAPED"
exit 0
