#!/usr/bin/env bash
# dev-stacks v4 — Stop gate (command-based)
# Blocks exit if code was written without verification
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
    # No code changes - allow exit
    sys.exit(0)

# Check for verification evidence
verification_patterns = [
    r'test', r'pytest', r'jest', r'mocha', r'npm test',
    r'go test', r'mvn test', r'gradle.*test',
    r'verified', r'passed', r'review',
    r'build.*success', r'lint.*pass',
    r'VERIFIER COMPLETE', r'SENTINEL COMPLETE',
    r'✅', r'✓'
]

last_msg_lower = last_msg.lower()
has_verification = any(
    re.search(p, last_msg_lower) for p in verification_patterns
)

if has_verification:
    # Verification done - allow exit
    sys.exit(0)

# Check for unresolved error shown to user
error_patterns = [
    r'error:', r'failed:', r'exception:',
    r'❌', r'⚠️', r'ERROR', r'FAIL'
]
has_unresolved_error = any(
    re.search(p, last_msg) for p in error_patterns
)

if has_unresolved_error:
    # Error was shown to user - allow exit (they can decide)
    sys.exit(0)

# Code changes without verification - BLOCK
import json
response = {"ok": False, "reason": "Code changes without verification"}
print(json.dumps(response))
sys.exit(0)
PYEOF

exit 0
