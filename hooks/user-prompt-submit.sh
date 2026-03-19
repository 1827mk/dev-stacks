#!/bin/bash
# Dev-Stacks UserPromptSubmit Hook - Compact Version

set -euo pipefail
INPUT=$(cat)
USER_PROMPT=$(echo "$INPUT" | jq -r '.user_prompt // ""')

# Skip slash commands
[[ "$USER_PROMPT" == /* ]] && exit 0

# Intent detection
INTENT="OTHER"
COMPLEXITY="0.2"

if echo "$USER_PROMPT" | grep -qiE 'แก้|ซ่อม|ไม่ทำงาน|fix|repair|broken|error|bug'; then
    INTENT="FIX_BUG"
elif echo "$USER_PROMPT" | grep -qiE 'เพิ่ม|สร้าง|add|create|implement|new feature'; then
    INTENT="ADD_FEATURE"
elif echo "$USER_PROMPT" | grep -qiE 'เปลี่ยน|แก้ไข|ปรับ|change|modify|update|adjust'; then
    INTENT="MODIFY_BEHAVIOR"
elif echo "$USER_PROMPT" | grep -qiE 'ทำไม|หา|สาเหตุ|why|find|investigate|debug'; then
    INTENT="INVESTIGATE"
elif echo "$USER_PROMPT" | grep -qiE 'อธิบาย|ทำงานยังไง|explain|how does|tell me'; then
    INTENT="EXPLAIN"
fi

# Complexity scoring
if echo "$USER_PROMPT" | grep -qiE 'typo|แก้ typo|เปลี่ยนชื่อ|rename'; then
    COMPLEXITY="0.1"
elif echo "$USER_PROMPT" | grep -qiE 'payment|การเงิน|auth|login|database|drop|delete all'; then
    COMPLEXITY="0.7"
elif echo "$USER_PROMPT" | grep -qiE 'refactor|แยก|split|migrate'; then
    COMPLEXITY="0.5"
fi

# Workflow
WORKFLOW="Standard"
if (( $(echo "$COMPLEXITY < 0.2" | bc -l) )); then
    WORKFLOW="Quick"
elif (( $(echo "$COMPLEXITY >= 0.4" | bc -l) )) && (( $(echo "$COMPLEXITY < 0.6" | bc -l) )); then
    WORKFLOW="Careful"
elif (( $(echo "$COMPLEXITY >= 0.6" | bc -l) )); then
    WORKFLOW="Full"
fi

# Task type detection
TASK_TYPE="unknown"
PRIMARY="standard"
if echo "$USER_PROMPT" | grep -qiE 'UI|component|page|frontend|หน้า|ปุ่ม|form'; then
    TASK_TYPE="frontend"; PRIMARY="frontend-design"
elif echo "$USER_PROMPT" | grep -qiE 'API|endpoint|backend|server|ฐานข้อมูล|database'; then
    TASK_TYPE="backend"; PRIMARY="standard"
elif echo "$USER_PROMPT" | grep -qiE 'test|ทดสอบ|verify|check'; then
    TASK_TYPE="testing"; PRIMARY="TDD"
elif echo "$USER_PROMPT" | grep -qiE 'bug|error|แก้|fix|ซ่อม'; then
    TASK_TYPE="debugging"; PRIMARY="systematic-debugging"
fi

# Compact output (6 lines max)
cat << EOF
[DEV-STACKS] Intent: $INTENT | Complexity: $COMPLEXITY | Workflow: $WORKFLOW
Analysis: Task=$TASK_TYPE | Primary: $PRIMARY skill
Tools: MCP(context7,web_reader,serena,memory) | Skills(frontend-design,systematic-debugging,TDD)
Orchestration: For complexity>=0.4, use Skill tool with skill="dev-stacks:orchestrator"
Agents: thinker(planning) | builder(implementation) | tester(verification)
State: Read .dev-stacks/state.json | Save patterns to MCP memory after success
EOF

exit 0
