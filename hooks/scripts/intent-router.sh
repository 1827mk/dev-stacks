#!/usr/bin/env bash
# dev-stacks v4 — UserPromptSubmit: Intent classification + adaptive routing hint
# Input field: 'prompt' (verified from official docs — NOT user_prompt)
# Output: plain stdout → injected as context before Claude processes

set -uo pipefail

INPUT=$(cat)
PROMPT=$(printf '%s' "$INPUT" | python3 -c "import json,sys; print(json.load(sys.stdin).get('prompt',''))" 2>/dev/null || echo "")
CWD=$(printf '%s' "$INPUT" | python3 -c "import json,sys; print(json.load(sys.stdin).get('cwd',''))" 2>/dev/null || echo "")

# Skip slash commands
[[ "$PROMPT" == /* ]] && exit 0
[[ -z "$PROMPT" || ${#PROMPT} -lt 3 ]] && exit 0

python3 - "$PROMPT" << 'PYEOF'
import sys

prompt = sys.argv[1].lower() if len(sys.argv) > 1 else ""

# Intent classification — Thai + English
INTENTS = {
    "FIX_BUG":     (["bug","error","fix","crash","fail","broken","แก้","พัง","ไม่ทำงาน","ซ่อม"], 0.05),
    "ADD_FEATURE":  (["add","create","implement","new","feature","เพิ่ม","สร้าง","ทำ","พัฒนา"], 0.10),
    "MODIFY":       (["change","update","refactor","improve","modify","เปลี่ยน","ปรับ","แก้ไข"], 0.05),
    "EXPLAIN":      (["explain","how","what","why","อธิบาย","ทำไม","ยังไง","คืออะไร"], -0.15),
    "RESEARCH":     (["find","search","docs","lookup","หา","ค้นหา","ดู"], -0.15),
    "DESIGN":       (["design","architect","plan","structure","ออกแบบ","วางแผน","โครงสร้าง"], 0.10),
    "SECURITY":     (["security","auth","permission","vuln","inject","ความปลอดภัย"], 0.20),
    "CHECK":        (["review","check","verify","audit","ตรวจ","เช็ค"], 0.0),
}

scores = {}
for intent, (keywords, _) in INTENTS.items():
    scores[intent] = sum(1 for kw in keywords if kw in prompt)

best = max(scores, key=lambda k: scores[k]) if any(scores.values()) else "GENERAL"
_, delta = INTENTS.get(best, ([], 0.0))

# Complexity (start 0.25)
complexity = 0.25
HIGH = ["payment","auth","security","database","migration","oauth","webhook","encryption"]
MED  = ["api","integration","service","endpoint","component","hook"]
LOW  = ["typo","comment","rename","format","log","message","string"]

for kw in HIGH:
    if kw in prompt: complexity += 0.15
for kw in MED:
    if kw in prompt: complexity += 0.05
for kw in LOW:
    if kw in prompt: complexity -= 0.10

complexity += delta
complexity = max(0.10, min(1.0, round(complexity, 2)))

# Phase recommendation (optimized thresholds)
if complexity < 0.30:
    phase = "quick — handle directly"
    agents = "none"
elif complexity < 0.50:
    phase = "standard — scout + architect → builder"
    agents = "scout, architect, builder"
elif complexity < 0.70:
    phase = "careful — +verifier + sentinel"
    agents = "scout, architect, builder, verifier, sentinel"
else:
    phase = "full — +chronicler"
    agents = "scout, architect, builder, verifier, sentinel, chronicler"

# Adaptive hook hints
hooks = []
if best in ("FIX_BUG", "ADD_FEATURE", "MODIFY"):
    hooks.append("verify-loop")
if best == "SECURITY" or complexity >= 0.70:
    hooks.append("sentinel")
if best == "DESIGN":
    hooks.append("sequential-thinking + context7")

print(f"[dev-stacks] {best} | complexity: {complexity} | {phase}")
print(f"→ agents: {agents}")
if hooks:
    print(f"→ activate: {', '.join(hooks)}")
print(f"→ use /dev-stacks:do to run full workflow, or describe task directly")
PYEOF

exit 0
