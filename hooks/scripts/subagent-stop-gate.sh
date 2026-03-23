#!/usr/bin/env bash
# dev-stacks v4 — SubagentStop gate (command-based)
# Blocks subagent exit if code was written without completion header
# Input: JSON with transcript, last_assistant_message, stop_hook_active
# Output: nothing (allow) or JSON block response

set -uo pipefail

INPUT=$(cat)

# Check stop_hook_active flag
STOP_ACTIVE=$(printf '%s' "$INPUT" | python3 -c "
import json, sys
data = json.load(sys.stdin)
print(str(data.get('stop_hook_active', False)).lower())
" 2>/dev/null || echo "false")

# If stop_hook_active is true, never block
[[ "$STOP_ACTIVE" == "true" ]] && exit 0

# Extract transcript and last message
TRANSCRIPT=$(printf '%s' "$INPUT" | python3 -c "
import json, sys
data = json.load(sys.stdin)
print(data.get('transcript', ''))
" 2>/dev/null || echo "")

LAST_MSG=$(printf '%s' "$INPUT" | python3 -c "
import json, sys
data = json.load(sys.stdin)
print(data.get('last_assistant_message', ''))
" 2>/dev/null || echo "")

# Check for code changes (Write/Edit/MultiEdit)
python3 - "$TRANSCRIPT" "$LAST_MSG" << 'PYEOF'
import sys
import re

transcript = sys.argv[1] if len(sys.argv) > 1 else ""
last_msg = sys.argv[2] if len(sys.argv) > 2 else ""

# Check for Write/Edit/MultiEdit in transcript
code_pattern = r'"tool_name"\s*:\s*"(Write|Edit|MultiEdit)"'
has_code_changes = bool(re.search(code_pattern, transcript, re.IGNORECASE))

if not has_code_changes:
    # No code changes - allow exit (read-only agent)
    sys.exit(0)

# Check for completion headers
completion_headers = [
    'SCOUT COMPLETE',
    'ARCHITECT PLAN',
    'BUILDER COMPLETE',
    'VERIFIER COMPLETE',
    'SENTINEL COMPLETE',
    'CHRONICLER COMPLETE',
    'HANDOFF VERIFIED',
    'DESIGN COMPLETE'
]

has_header = any(header in last_msg for header in completion_headers)

if has_header:
    # Has completion header - allow exit
    sys.exit(0)

# Code changes without completion header - BLOCK
import json
response = {"block": True, "reason": "Code changes detected but no completion header found. Add appropriate header (SCOUT COMPLETE, BUILDER COMPLETE, etc.) before stopping."}
print(json.dumps(response))
sys.exit(0)
PYEOF

exit 0
