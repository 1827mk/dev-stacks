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

# Combined Thai + English keywords (fixed: no longer overwriting Thai results)
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

# Intelligence Layer: Task Analysis
TASK_TYPE="unknown"
DOMAIN="general"
CONFIDENCE="0.5"

# Detect task type
if echo "$USER_PROMPT" | grep -qiE 'UI|component|page|frontend|หน้า|ปุ่ม|form'; then
    TASK_TYPE="frontend"
    DOMAIN="UI/UX"
    CONFIDENCE="0.85"
elif echo "$USER_PROMPT" | grep -qiE 'API|endpoint|backend|server|ฐานข้อมูล|database'; then
    TASK_TYPE="backend"
    DOMAIN="Backend/API"
    CONFIDENCE="0.80"
elif echo "$USER_PROMPT" | grep -qiE 'test|ทดสอบ|verify|check'; then
    TASK_TYPE="testing"
    DOMAIN="QA/Testing"
    CONFIDENCE="0.75"
elif echo "$USER_PROMPT" | grep -qiE 'bug|error|แก้|fix|ซ่อม'; then
    TASK_TYPE="debugging"
    DOMAIN="Debugging"
    CONFIDENCE="0.80"
fi

# Recommend primary approach
PRIMARY_APPROACH="standard"
if [[ "$TASK_TYPE" == "frontend" ]]; then
    PRIMARY_APPROACH="frontend-design skill"
elif [[ "$TASK_TYPE" == "debugging" ]]; then
    PRIMARY_APPROACH="systematic-debugging skill"
elif [[ "$TASK_TYPE" == "testing" ]]; then
    PRIMARY_APPROACH="test-driven-development skill"
fi

# Output routing info + Intelligence Layer + orchestration instruction
cat << ROUTING
🔍 [DEV-STACKS] Intent: $INTENT | Complexity: $COMPLEXITY | Workflow: $WORKFLOW

🧠 INTELLIGENCE LAYER
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Analysis:
  • Task type: $TASK_TYPE
  • Domain: $DOMAIN
  • Complexity factors: $([[ $COMPLEXITY > 0.5 ]] && echo "Multiple components, careful planning needed" || echo "Straightforward task")

Recommended Approach:
  • Primary: $PRIMARY_APPROACH
  • Confidence: $CONFIDENCE

Available Tools:
  • MCP: context7, web_reader, WebSearch, serena, memory
  • Skills: frontend-design, systematic-debugging, TDD, brainstorming
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📋 ORCHESTRATION INSTRUCTION:
Invoke the orchestrator skill to manage this task:
  • Use Skill tool with skill="dev-stacks:orchestrator"
  • Orchestrator will handle state machine and agent dispatch
  • Do NOT implement directly - let the team handle it
ROUTING

exit 0
