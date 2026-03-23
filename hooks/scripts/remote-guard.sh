#!/usr/bin/env bash
# dev-stacks v4 — remote-guard (PreToolUse: Bash)

set -uo pipefail
INPUT=$(cat)
CMD=$(printf '%s' "$INPUT" | python3 -c "import json,sys; print(json.load(sys.stdin).get('tool_input',{}).get('command',''))" 2>/dev/null || echo "")
[[ -z "$CMD" ]] && exit 0

REASON=""
printf '%s' "$CMD" | grep -qE 'curl\s.+\|\s*(bash|sh|zsh)' && REASON="curl piped to shell — executes remote code without inspection"
printf '%s' "$CMD" | grep -qE 'wget\s.+\|\s*(bash|sh|zsh)' && REASON="wget piped to shell — executes remote code without inspection"
printf '%s' "$CMD" | grep -qE 'eval\s*\$\((curl|wget)' && REASON="eval with remote fetch — executes remote code without inspection"

if [[ -n "$REASON" ]]; then
  printf '{"decision":"block","reason":"🛡️ REMOTE GUARD: %s\n\nDownload script first, inspect it, then run after user confirmation."}\n' "$REASON" >&2
  exit 2
fi
exit 0
