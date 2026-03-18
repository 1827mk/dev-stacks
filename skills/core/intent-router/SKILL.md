---
name: intent-router
description: Detect user intent from natural language input (Thai/English/Mixed). Use before any task to understand what user wants.
---

# Intent Router

Detects user intent from natural language input. Supports Thai, English, and Mixed language.

## Purpose

Transform user's natural language into structured intent data for workflow routing.

## Process

1. **Analyze Input**
   - Parse user message
   - Identify action keywords
   - Detect target (file, function, module)
   - Extract context hints

2. **Detect Language**
   - Thai (>= 30% Thai characters)
   - English (no Thai characters)
   - Mixed (Thai + English)

3. **Classify Intent Category**

| Category | Thai Keywords | English Keywords |
|----------|---------------|------------------|
| FIX_BUG | แก้, ซ่อม, ไม่ทำงาน, error, bug | fix, repair, broken, error, bug |
| ADD_FEATURE | เพิ่ม, สร้าง, implement, new | add, create, implement, new feature |
| MODIFY_BEHAVIOR | เปลี่ยน, แก้ไข, update, ปรับ | change, modify, update, adjust |
| OPTIMIZE | เร็ว, optimize, ปรับปรุง, improve | fast, optimize, improve, speed up |
| INVESTIGATE | ทำไม, หา, สาเหตุ, investigate | why, find, investigate, debug |
| EXPLAIN | อธิบาย, ทำงานยังไง, how | explain, how does, tell me about |
| SETUP | ตั้งค่า, config, initialize | setup, configure, initialize |
| DEPLOY | deploy, publish, release | deploy, publish, release |
| OTHER | (default) | (default) |

4. **Extract Target**
   - File path (e.g., "src/auth/login.ts")
   - Function/module name
   - Feature area (e.g., "login validation")

5. **Return Structured Intent**

## Output Format

```json
{
  "category": "FIX_BUG",
  "target": "login validation",
  "description": "แก้ bug ใน login validation",
  "language": "MIXED",
  "context": ["form validation", "error handling"],
  "confidence": 0.92
}
```

## Examples

### Example 1: Thai Input
```
Input: "แก้ typo ใน README ตรงคำว่า intallation"

Output:
{
  "category": "FIX_BUG",
  "target": "README.md",
  "description": "แก้ typo ใน README ตรงคำว่า intallation",
  "language": "TH",
  "context": ["documentation", "typo"],
  "confidence": 0.95
}
```

### Example 2: English Input
```
Input: "Add email validation to the login form"

Output:
{
  "category": "ADD_FEATURE",
  "target": "login form validation",
  "description": "Add email validation to the login form",
  "language": "EN",
  "context": ["form validation", "email", "login"],
  "confidence": 0.90
}
```

### Example 3: Mixed Input
```
Input: "แก้ login flow ตรง session timeout handling"

Output:
{
  "category": "FIX_BUG",
  "target": "session timeout handling in login flow",
  "description": "แก้ login flow ตรง session timeout handling",
  "language": "MIXED",
  "context": ["login", "session", "timeout"],
  "confidence": 0.88
}
```

## Ambiguity Handling

If intent is unclear (confidence < 0.7):

```
🤔 Intent unclear. Please clarify:

1. Fix a bug? (แก้ไขปัญหา)
2. Add a feature? (เพิ่มฟีเจอร์ใหม่)
3. Investigate an issue? (ตรวจสอบปัญหา)

Reply with number or describe your intent.
```

## Usage

This skill is automatically invoked by UserPromptSubmit hook for every user message.
