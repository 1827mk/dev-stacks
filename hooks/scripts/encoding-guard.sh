#!/usr/bin/env bash
# dev-stacks v4 — Encoding Guard (PreToolUse: Write|Edit)
# Blocks changes to file encoding - NEVER allow encoding conversion

set -uo pipefail
INPUT=$(cat)

# Extract file path
FILE_PATH=$(printf '%s' "$INPUT" | python3 -c "
import json, sys
data = json.load(sys.stdin)
tool_input = data.get('tool_input', {})
print(tool_input.get('file_path', tool_input.get('path', '')))
" 2>/dev/null || echo "")

[[ -z "$FILE_PATH" ]] && exit 0
[[ ! -f "$FILE_PATH" ]] && exit 0  # New file, allow

# Check current encoding
CURRENT_ENCODING=$(file -b --mime-encoding "$FILE_PATH" 2>/dev/null || echo "unknown")

# Allowed encodings (these should never change)
ALLOWED=("utf-8" "us-ascii" "unknown")

IS_ALLOWED=0
for enc in "${ALLOWED[@]}"; do
  [[ "$CURRENT_ENCODING" == "$enc" ]] && IS_ALLOWED=1 && break
done

if [[ $IS_ALLOWED -eq 0 ]]; then
  # File has unusual encoding - warn but don't block
  printf '{"block": false, "reason": "⚠️ ENCODING: %s uses %s encoding — preserve it exactly"}\n' \
    "$FILE_PATH" "$CURRENT_ENCODING" >&2
fi

# Check if content being written would change encoding
CONTENT=$(printf '%s' "$INPUT" | python3 -c "
import json, sys
data = json.load(sys.stdin)
tool_input = data.get('tool_input', {})
print(tool_input.get('content', ''))
" 2>/dev/null || echo "")

# Check for BOM markers that would change encoding
if printf '%s' "$CONTENT" | head -c 3 | xxd -p | grep -q "efbbbf"; then
  printf '{"block": true, "reason": "🚫 ENCODING GUARD: Attempting to add UTF-8 BOM to %s — files must remain without BOM"}\n' \
    "$FILE_PATH" >&2
  exit 2
fi

# Check for null bytes (would indicate binary or UTF-16)
if printf '%s' "$CONTENT" | grep -q $'\x00'; then
  printf '{"block": true, "reason": "🚫 ENCODING GUARD: Null bytes detected — would corrupt %s"}\n' \
    "$FILE_PATH" >&2
  exit 2
fi

exit 0
