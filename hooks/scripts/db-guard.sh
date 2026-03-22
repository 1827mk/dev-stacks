#!/usr/bin/env bash
# dev-stacks v4 — db-guard (PreToolUse: Bash)

set -euo pipefail
INPUT=$(cat)
CMD=$(printf '%s' "$INPUT" | python3 -c "import json,sys; print(json.load(sys.stdin).get('tool_input',{}).get('command',''))" 2>/dev/null || echo "")
[[ -z "$CMD" ]] && exit 0

U=$(printf '%s' "$CMD" | tr '[:lower:]' '[:upper:]')
REASON=""

printf '%s' "$U" | grep -qE 'DROP[[:space:]]+(TABLE|DATABASE|SCHEMA|INDEX)' && REASON="DROP operation detected — permanently deletes database objects"
printf '%s' "$U" | grep -qE 'TRUNCATE[[:space:]]+' && REASON="TRUNCATE detected — deletes all rows, no rollback"
if printf '%s' "$U" | grep -qE 'DELETE[[:space:]]+FROM' && ! printf '%s' "$U" | grep -qE 'WHERE[[:space:]]+'; then
  REASON="DELETE without WHERE — will delete ALL rows"
fi
if printf '%s' "$U" | grep -qE 'UPDATE[[:space:]]+[A-Z_]+[[:space:]]+SET' && ! printf '%s' "$U" | grep -qE 'WHERE[[:space:]]+'; then
  REASON="UPDATE without WHERE — will update ALL rows"
fi

if [[ -n "$REASON" ]]; then
  printf '{"decision":"block","reason":"🛡️ DB GUARD: %s\nCommand: %s\n\nConfirm with user before proceeding."}\n' "$REASON" "$CMD" >&2
  exit 2
fi
exit 0
