#!/usr/bin/env bash
# dev-stacks v4 — SessionStart
# Loads: MCP memory patterns + Serena DNA + snapshot → inject as additionalContext
# Output format: hookSpecificOutput.additionalContext (verified from official docs)

set -uo pipefail

INPUT=$(cat)
CWD=$(printf '%s' "$INPUT" | python3 -c "import json,sys; print(json.load(sys.stdin).get('cwd',''))" 2>/dev/null || echo "")
SESSION_ID=$(printf '%s' "$INPUT" | python3 -c "import json,sys; print(json.load(sys.stdin).get('session_id','unknown'))" 2>/dev/null || echo "unknown")

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$CWD}"
DS_DIR="$PROJECT_DIR/.dev-stacks"
DNA="$DS_DIR/dna.json"
SNAPSHOT="$DS_DIR/snapshot.md"
LEDGER="$DS_DIR/error-ledger.jsonl"

mkdir -p "$DS_DIR/logs"

LINES=()
LINES+=("=== dev-stacks v4 | session: $SESSION_ID ===")

# DNA summary
if [[ -f "$DNA" ]]; then
  NAME=$(python3 -c "import json; d=json.load(open('$DNA')); print(d.get('project',{}).get('name','?'))" 2>/dev/null || echo "?")
  LANGS=$(python3 -c "import json; d=json.load(open('$DNA')); print(', '.join(d.get('project',{}).get('languages',[])))" 2>/dev/null || echo "")
  RISKS=$(python3 -c "import json; d=json.load(open('$DNA')); print(', '.join(d.get('risk_areas',[])))" 2>/dev/null || echo "none")
  LINES+=("project: $NAME | stack: $LANGS | risk: $RISKS")
else
  LINES+=("DNA not found — run /dev-stacks:init")
fi

# Error patterns from ledger (instinct injection)
if [[ -f "$LEDGER" ]]; then
  # Count patterns with count >= 3
  PATTERNS=$(python3 - << 'PYEOF'
import json, sys, collections
ledger_path = sys.argv[1] if len(sys.argv) > 1 else ""
counts = collections.Counter()
try:
    with open(ledger_path) as f:
        for line in f:
            line = line.strip()
            if not line: continue
            try:
                entry = json.loads(line)
                key = entry.get("pattern_key", "")
                if key:
                    counts[key] += 1
            except: pass
    instincts = [f"⚠️ {k} (seen {v}x)" for k, v in counts.most_common(5) if v >= 3]
    if instincts:
        print("INSTINCTS (known patterns to watch):")
        for i in instincts:
            print(f"  {i}")
except: pass
PYEOF
)
  if [[ -n "$PATTERNS" ]]; then
    LINES+=("")
    LINES+=("$PATTERNS")
  fi
fi

# Active snapshot
if [[ -f "$SNAPSHOT" ]]; then
  LINES+=("")
  LINES+=("=== ACTIVE TASK (from last session) ===")
  while IFS= read -r line; do LINES+=("$line"); done < "$SNAPSHOT"
  LINES+=("=== end snapshot ===")
  LINES+=("⚠️ Read snapshot before doing anything.")
else
  LINES+=("")
  LINES+=("commands: /dev-stacks  /dev-stacks:think  /dev-stacks:do  /dev-stacks:check  /dev-stacks:learn  /dev-stacks:memory  /dev-stacks:init")
fi

CONTEXT=$(printf '%s\n' "${LINES[@]}")

ESCAPED=$(python3 -c "
import json, sys
print(json.dumps(sys.stdin.read())[1:-1])
" <<< "$CONTEXT")

printf '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"%s"}}\n' "$ESCAPED"
exit 0
