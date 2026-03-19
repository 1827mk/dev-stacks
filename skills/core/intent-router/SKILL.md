---
name: intent-router
description: Detect user intent from natural language (Thai/English/Mixed). Auto-invoked by hook.
---

# Intent Router

Parse user input into structured intent for workflow routing.

## Intent Categories

| Category | Thai Keywords | English Keywords |
|----------|---------------|------------------|
| FIX_BUG | แก้, ซ่อม, ไม่ทำงาน, error, bug | fix, repair, broken, error, bug |
| ADD_FEATURE | เพิ่ม, สร้าง, implement | add, create, implement, new feature |
| MODIFY_BEHAVIOR | เปลี่ยน, แก้ไข, ปรับ | change, modify, update, adjust |
| OPTIMIZE | เร็ว, optimize, ปรับปรุง | fast, optimize, improve, speed up |
| INVESTIGATE | ทำไม, หา, สาเหตุ | why, find, investigate, debug |
| EXPLAIN | อธิบาย, ทำงานยังไง | explain, how does, tell me about |
| SETUP | ตั้งค่า, config, initialize | setup, configure, initialize |
| DEPLOY | deploy, publish, release | deploy, publish, release |
| OTHER | (default) | (default) |

## Language Detection

- Thai: >= 30% Thai characters
- English: No Thai characters
- Mixed: Thai + English

## Output Format

```json
{
  "category": "ADD_FEATURE",
  "target": "login form validation",
  "description": "เพิ่ม email validation ใน login form",
  "language": "MIXED",
  "context": ["form validation", "email"],
  "confidence": 0.90
}
```

## Low Confidence ( < 0.7 )

Ask user to clarify:
```
Intent unclear. Options:
1. Fix a bug?
2. Add a feature?
3. Investigate?
Reply with number or describe.
```

## Usage

Automatically invoked by UserPromptSubmit hook. No manual invocation needed.
