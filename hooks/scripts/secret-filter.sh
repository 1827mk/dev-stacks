#!/usr/bin/env bash
# dev-stacks v4 — secret-filter (PostToolUse)

set -uo pipefail
INPUT=$(cat)
CONTENT=$(printf '%s' "$INPUT" | python3 -c "
import json,sys
d=json.load(sys.stdin)
parts=[]
tr=d.get('tool_response',{})
if isinstance(tr,dict):
    parts.append(str(tr.get('content','')))
    parts.append(str(tr.get('output','')))
ti=d.get('tool_input',{})
if isinstance(ti,dict):
    parts.append(str(ti.get('content','')))
print('\n'.join(parts))
" 2>/dev/null || echo "")
[[ -z "$CONTENT" ]] && exit 0

FOUND=0; FINDINGS=""
chk() { printf '%s' "$CONTENT" | grep -qE "$2" && { FOUND=1; FINDINGS="$FINDINGS\n- $1"; }; }

chk "AWS Access Key"       'AKIA[0-9A-Z]{16}'
chk "Generic API Key"      '(api[_-]?key|apikey)\s*[:=]\s*["\x27]?[A-Za-z0-9\-_]{20,}'
chk "Password in code"     '(password|passwd|pwd)\s*[:=]\s*["\x27][^"\x27\s]{8,}'
chk "Bearer Token"         'Bearer\s+[A-Za-z0-9\-_\.]{20,}'
chk "Private Key"          '\-\-\-\-\-BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY'
chk "JWT Token"            'eyJ[A-Za-z0-9\-_]+\.eyJ[A-Za-z0-9\-_]+\.'
chk "GitHub Token"         'gh[ps]_[A-Za-z0-9]{36,}'
chk "Database URL+creds"   '(mysql|postgres|mongodb):\/\/[^:]+:[^@]+@'

if [[ $FOUND -eq 1 ]]; then
  printf '{"decision":"block","reason":"🔐 SECRET FILTER: Potential secrets in output:\n%s\n\nRemove secrets — use env vars or secret managers instead."}\n' \
    "$(printf '%s' "$FINDINGS")" >&2
  exit 2
fi
exit 0
