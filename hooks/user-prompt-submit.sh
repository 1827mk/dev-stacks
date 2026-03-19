#!/bin/bash
# Dev-Stacks UserPromptSubmit Hook
# Analyze user intent and display routing info

set -euo pipefail

# Read JSON input from stdin
INPUT=$(cat)

# Extract user prompt
USER_PROMPT=$(echo "$INPUT" | jq -r '.user_prompt // ""')

# Skip if it's a slash command
if [[ "$USER_PROMPT" == /* ]]; then
    exit 0
fi

# Simple intent detection
INTENT="OTHER"
COMPLEXITY="0.2"

# Thai keywords
if echo "$USER_PROMPT" | grep -qiE 'แก้|ซ่อม|ไม่ทำงาน|error|bug'; then
    INTENT="FIX_BUG"
elif echo "$USER_PROMPT" | grep -qiE 'เพิ่ม|สร้าง|implement|new'; then
    INTENT="ADD_FEATURE"
elif echo "$USER_PROMPT" | grep -qiE 'เปลี่ยน|แก้ไข|update|ปรับ'; then
    INTENT="MODIFY_BEHAVIOR"
elif echo "$USER_PROMPT" | grep -qiE 'ทำไม|หา|สาเหตุ|investigate|why'; then
    INTENT="INVESTIGATE"
elif echo "$USER_PROMPT" | grep -qiE 'อธิบาย|ทำงานยังไง|how|explain'; then
    INTENT="EXPLAIN"
fi

# English keywords
if echo "$USER_PROMPT" | grep -qiE 'fix|repair|broken|error'; then
    INTENT="FIX_BUG"
elif echo "$USER_PROMPT" | grep -qiE 'add|create|implement|new feature'; then
    INTENT="ADD_FEATURE"
elif echo "$USER_PROMPT" | grep -qiE 'change|modify|update|adjust'; then
    INTENT="MODIFY_BEHAVIOR"
elif echo "$USER_PROMPT" | grep -qiE 'why|find|investigate|debug'; then
    INTENT="INVESTIGATE"
elif echo "$USER_PROMPT" | grep -qiE 'explain|how does|tell me'; then
    INTENT="EXPLAIN"
fi

# Simple complexity scoring
if echo "$USER_PROMPT" | grep -qiE 'typo|แก้ typo|เปลี่ยนชื่อ|rename'; then
    COMPLEXITY="0.1"
elif echo "$USER_PROMPT" | grep -qiE 'payment|การเงิน|auth|login|database|drop|delete all'; then
    COMPLEXITY="0.7"
elif echo "$USER_PROMPT" | grep -qiE 'refactor|แยก|split|migrate'; then
    COMPLEXITY="0.5"
fi

# Determine workflow
WORKFLOW="Standard"
if (( $(echo "$COMPLEXITY < 0.2" | bc -l) )); then
    WORKFLOW="Quick"
elif (( $(echo "$COMPLEXITY >= 0.4" | bc -l) )) && (( $(echo "$COMPLEXITY < 0.6" | bc -l) )); then
    WORKFLOW="Careful"
elif (( $(echo "$COMPLEXITY >= 0.6" | bc -l) )); then
    WORKFLOW="Full"
fi

# Output routing info (stdout is added as context)
cat << ROUTING
🔍 [DEV-STACKS] Intent: $INTENT | Complexity: $COMPLEXITY | Workflow: $WORKFLOW
ROUTING

exit 0
