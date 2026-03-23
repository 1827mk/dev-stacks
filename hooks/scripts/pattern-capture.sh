#!/usr/bin/env bash
# dev-stacks v4 — pattern-capture (PostToolUse: Write|Edit|MultiEdit)
# Captures what files were changed for self-learner to process
# Lightweight — just logs file path + timestamp, never blocks

set -uo pipefail

INPUT=$(cat)
CWD=$(printf '%s' "$INPUT" | python3 -c "import json,sys; print(json.load(sys.stdin).get('cwd',''))" 2>/dev/null || echo "")
FILE=$(printf '%s' "$INPUT" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d.get('tool_input',{}).get('file_path',''))" 2>/dev/null || echo "")
TOOL=$(printf '%s' "$INPUT" | python3 -c "import json,sys; print(json.load(sys.stdin).get('tool_name',''))" 2>/dev/null || echo "")

[[ -z "$FILE" ]] && exit 0

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$CWD}"
DS_DIR="$PROJECT_DIR/.dev-stacks"
mkdir -p "$DS_DIR"

TS=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
printf '{"ts":"%s","tool":"%s","file":"%s"}\n' "$TS" "$TOOL" "$FILE" >> "$DS_DIR/change-log.jsonl"

exit 0
