#!/usr/bin/env bash
# dev-stacks v4 — SubagentStart
# Injects DNA + top error patterns into every spawned agent
# Output: hookSpecificOutput.additionalContext (verified format)

set -euo pipefail

INPUT=$(cat)
CWD=$(printf '%s' "$INPUT" | python3 -c "import json,sys; print(json.load(sys.stdin).get('cwd',''))" 2>/dev/null || echo "")
AGENT_TYPE=$(printf '%s' "$INPUT" | python3 -c "import json,sys; print(json.load(sys.stdin).get('agent_type','unknown'))" 2>/dev/null || echo "unknown")

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$CWD}"
DS_DIR="$PROJECT_DIR/.dev-stacks"
DNA="$DS_DIR/dna.json"
LEDGER="$DS_DIR/error-ledger.jsonl"

LINES=()
LINES+=("[dev-stacks] agent: $AGENT_TYPE | project: $PROJECT_DIR")

# DNA
if [[ -f "$DNA" ]]; then
  NAME=$(python3 -c "import json; d=json.load(open('$DNA')); print(d.get('project',{}).get('name','?'))" 2>/dev/null || echo "?")
  LANGS=$(python3 -c "import json; d=json.load(open('$DNA')); print(', '.join(d.get('project',{}).get('languages',[])))" 2>/dev/null || echo "")
  AUTH=$(python3 -c "import json; d=json.load(open('$DNA')); print(d.get('critical_paths',{}).get('auth','unknown'))" 2>/dev/null || echo "unknown")
  RISKS=$(python3 -c "import json; d=json.load(open('$DNA')); print(', '.join(d.get('risk_areas',[])))" 2>/dev/null || echo "none")
  LINES+=("stack: $LANGS | auth: $AUTH | risks: $RISKS")
fi

# Top error patterns
if [[ -f "$LEDGER" ]]; then
  TOP=$(python3 - "$LEDGER" << 'PYEOF'
import json, sys, collections
counts = collections.Counter()
try:
    with open(sys.argv[1]) as f:
        for line in f:
            line = line.strip()
            if not line: continue
            try:
                entry = json.loads(line)
                k = entry.get("pattern_key","")
                if k: counts[k] += 1
            except: pass
    top = [f"{k}({v}x)" for k,v in counts.most_common(3) if v >= 2]
    if top: print("known issues: " + ", ".join(top))
except: pass
PYEOF
)
  [[ -n "$TOP" ]] && LINES+=("$TOP")
fi

LINES+=("rules: read-before-write | ask-before-search | never-git-add | ask-when-unsure")

CONTEXT=$(printf '%s\n' "${LINES[@]}")
ESCAPED=$(python3 -c "import json,sys; print(json.dumps(sys.stdin.read())[1:-1])" <<< "$CONTEXT")

printf '{"hookSpecificOutput":{"hookEventName":"SubagentStart","additionalContext":"%s"}}\n' "$ESCAPED"
exit 0
