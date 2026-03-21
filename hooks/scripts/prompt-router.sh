#!/usr/bin/env bash
# dev-stacks v3 — UserPromptSubmit hook
# Input field: 'prompt' (NOT user_prompt — verified from official docs)
# Output: plain stdout → injected as context before Claude processes prompt
# No jq — uses python3 only

set -euo pipefail

INPUT=$(cat)

# VERIFIED: field name is 'prompt' per official docs
PROMPT=$(printf '%s' "$INPUT" | python3 -c "import json,sys; print(json.load(sys.stdin).get('prompt',''))" 2>/dev/null || echo "")
SESSION_ID=$(printf '%s' "$INPUT" | python3 -c "import json,sys; print(json.load(sys.stdin).get('session_id','unknown'))" 2>/dev/null || echo "unknown")
CWD=$(printf '%s' "$INPUT" | python3 -c "import json,sys; print(json.load(sys.stdin).get('cwd',''))" 2>/dev/null || echo "")

# Skip slash commands — don't classify /dev-stacks:* calls
if [[ "$PROMPT" == /* ]]; then
  exit 0
fi

# Skip empty prompts
if [[ -z "$PROMPT" || ${#PROMPT} -lt 3 ]]; then
  exit 0
fi

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$CWD}"
REGISTRY="$PROJECT_DIR/.dev-stacks/registry.json"

# Classify using python3 (no jq dependency)
python3 - "$PROMPT" "$REGISTRY" << 'PYEOF'
import sys, json, os, re

prompt_raw = sys.argv[1] if len(sys.argv) > 1 else ""
registry_path = sys.argv[2] if len(sys.argv) > 2 else ""
prompt = prompt_raw.lower()

# Intent classification — Thai + English
INTENTS = {
    "FIX_BUG":     ["bug", "error", "fix", "crash", "exception", "broken", "fail", "wrong",
                    "แก้", "ซ่อม", "ไม่ได้", "ไม่ทำงาน", "พัง", "ผิดพลาด", "ล้ม"],
    "ADD_FEATURE":  ["add", "create", "implement", "new", "feature", "build",
                    "เพิ่ม", "สร้าง", "ทำ", "เขียน", "พัฒนา"],
    "MODIFY":       ["change", "update", "modify", "refactor", "improve", "edit", "rename",
                    "เปลี่ยน", "แก้ไข", "ปรับ", "ปรับปรุง"],
    "EXPLAIN":      ["explain", "how", "what", "why", "show", "describe",
                    "อธิบาย", "ทำไม", "ยังไง", "คืออะไร", "บอก"],
    "RESEARCH":     ["find", "search", "lookup", "docs", "research", "check",
                    "หา", "ค้นหา", "ดู", "ตรวจ"],
    "DESIGN":       ["design", "architect", "plan", "structure", "model",
                    "ออกแบบ", "วางแผน", "โครงสร้าง"],
    "SECURITY":     ["security", "auth", "permission", "vuln", "inject", "xss", "csrf",
                    "ความปลอดภัย", "สิทธิ์"],
}

# Score
scores = {}
for intent, keywords in INTENTS.items():
    scores[intent] = sum(1 for kw in keywords if kw in prompt)

best_intent = max(scores, key=lambda k: scores[k]) if any(scores.values()) else "GENERAL"

# Complexity scoring
complexity = 0.20
HIGH_KW = ["payment", "auth", "security", "database", "migration", "architecture",
           "oauth", "webhook", "encryption", "ชำระเงิน", "ความปลอดภัย"]
MED_KW  = ["api", "integration", "service", "endpoint", "component", "hook"]
LOW_KW  = ["typo", "comment", "rename", "format", "log", "message"]

for kw in HIGH_KW:
    if kw in prompt: complexity += 0.15
for kw in MED_KW:
    if kw in prompt: complexity += 0.05
for kw in LOW_KW:
    if kw in prompt: complexity -= 0.10

INTENT_DELTA = {
    "FIX_BUG": 0.05, "ADD_FEATURE": 0.10, "MODIFY": 0.05,
    "EXPLAIN": -0.15, "RESEARCH": -0.15, "DESIGN": 0.10,
    "SECURITY": 0.20, "GENERAL": 0.0
}
complexity += INTENT_DELTA.get(best_intent, 0)
complexity = max(0.10, min(1.0, complexity))

# Workflow
if complexity < 0.20:   workflow = "quick"
elif complexity < 0.40: workflow = "standard"
elif complexity < 0.60: workflow = "careful"
else:                   workflow = "full"

WORKFLOW_DESC = {
    "quick":    "handle directly — no agents needed",
    "standard": "thinker → builder",
    "careful":  "thinker → builder → reviewer",
    "full":     "thinker → builder → reviewer×2 (parallel)",
}

# Output: plain stdout → injected as context
print(f"[dev-stacks] {best_intent} | complexity: {complexity:.2f} | workflow: {workflow}")
print(f"→ {WORKFLOW_DESC[workflow]}")
if workflow != "quick":
    print(f"→ use /dev-stacks:agents to run workflow, or describe task directly")
PYEOF

exit 0
