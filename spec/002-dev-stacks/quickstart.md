# Quickstart: Dev-Stacks

**Feature**: 002-dev-stacks
**Created**: 2026-03-18
**Updated**: 2026-03-18

---

## 30-Second Summary

Dev-Stacks ช่วยคุณทำงานกับ AI ได้เร็วขึ้นโดย:
1. **พูดแล้วเกิด action** - ไม่ต้องจำ command
2. **งานเล็กทำน้อย งานใหญ่ทำมาก** - Adaptive workflow
3. **ปลอดภัยเสมอ** - Guards ป้องกัน และ undo ได้ทุกอย่าง

**Architecture**: Pure Markdown-First - Claude Intelligence Driven

---

## Installation

### Prerequisites

- Claude Code installed
- MCP Memory server configured (for pattern storage)
- MCP Filesystem server configured (for checkpoints/DNA)

### 1. Add to Project

```bash
# Copy plugin directory to your project
cp -r dev-stacks/ .claude/plugins/dev-stacks/

# Or install globally
cp -r dev-stacks/ ~/.claude/plugins/dev-stacks/
```

### 2. Initialize

```
# Start Claude Code in your project
cd your-project
claude

# Plugin auto-initializes on first session
# Creates .dev-stack/ directory with:
#   - dna.json (project knowledge)
#   - checkpoint.json (session state)
#   - audit.jsonl (audit log)
#
# Patterns stored in MCP Memory (Knowledge Graph)
```

---

## First Task

### Quick Fix (งานเล็ก)

```
You: "แก้ typo ใน README ตรงคำว่า 'intallation'"

Dev-Stacks:
🎯 Intent: FIX_BUG | Target: README.md
📊 Complexity: 0.1 (Quick)
👥 Team: [Builder]
⚡ Proceeding...

✅ Fixed: Changed 'intallation' → 'installation' in README.md:23
```

### Feature Development (งานกลาง)

```
You: "เพิ่ม validation ในฟอร์ม login ให้ตรวจสอบ email format"

Dev-Stacks:
🎯 Intent: ADD_FEATURE | Target: login form validation
📊 Complexity: 0.35 (Standard)
👥 Team: [Thinker, Builder]
⚡ Proceeding in 3s...

🧠 Thinker: Analyzing...
   - Found: src/components/LoginForm.tsx
   - Need: Add email validation

🛠️ Builder: Implementing...
   - Added email regex validation
   - Updated error messages

✅ Done!
```

### Investigation (งานสืบหา)

```
You: "ทำไม API /users ช้า?"

Dev-Stacks:
🎯 Intent: INVESTIGATE | Target: /users API performance
📊 Complexity: 0.4 (Careful)
👥 Team: [Thinker, Builder, Tester]

🧠 Thinker: Investigating...
   - Checking database queries
   - Checking N+1 patterns
   - Checking caching

📋 Findings:
   1. Missing index on users.email
   2. N+1 query in getUserRoles()
   3. No caching for user profiles

💡 Recommendations:
   1. Add index: CREATE INDEX idx_users_email ON users(email)
   2. Eager load roles
   3. Add Redis cache

   Implement fixes? [Y/n]
```

---

## Core Concepts

### Research Capability

Dev-Stacks agents ทำงานเหมือน developer เก่งๆ ที่สามารถ **ค้นคว้าหาความรู้เพิ่มเติม** เมื่อไม่รู้:

```
You: "ใช้ Zod สำหรับ validation ใน React form"

Dev-Stacks:
🧠 Thinker: I need to research Zod validation patterns...
📚 Researching Zod form validation...

Research Findings:
   - Zod schema definition
   - React Hook Form integration
   - Error handling patterns

🧠 THINKER ANALYSIS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Based on research, I'll use:
- Zod for schema validation
- React Hook Form for form state
- Custom error display component
...
```

**Research Tools Available**:
| Tool | Purpose |
|------|---------|
| context7 | Library documentation |
| web_reader | Articles, tutorials |
| WebSearch | Solutions, best practices |
| fetch | Specific URLs |

---

### Intent Categories

| Intent | ตัวอย่าง |
|--------|----------|
| `FIX_BUG` | "แก้ bug", "fix error", "ไม่ทำงาน" |
| `ADD_FEATURE` | "เพิ่ม", "สร้าง", "implement" |
| `MODIFY_BEHAVIOR` | "เปลี่ยน", "แก้ไข", "update" |
| `OPTIMIZE` | "เร็ว", "optimize", "ปรับปรุง" |
| `INVESTIGATE` | "ทำไม", "หา", "สาเหตุ" |
| `EXPLAIN` | "อธิบาย", "ทำงานยังไง" |

### Complexity Levels

| Score | Level | Team | Workflow |
|-------|-------|------|----------|
| 0.0-0.19 | Quick | Builder | Build → Done |
| 0.2-0.39 | Standard | Thinker + Builder | Think → Build → Done |
| 0.4-0.59 | Careful | Thinker + Builder + Tester | Think → Build → Test → Done |
| 0.6-1.0 | Full | Full Team + Confirm | Plan → Build → Test → Review → Done |

### Agents

| Agent | Role | เข้าร่วมเมื่อ |
|-------|------|-------------|
| 🧠 Thinker | วิเคราะห์ วางแผน | Complexity ≥ 0.2 |
| 🛠️ Builder | Implement แก้ไข | ทุก task |
| ✅ Tester | Verify validate | Complexity ≥ 0.4 |

---

## Commands Reference

| Command | ใช้เมื่อ |
|---------|---------|
| `/dev-stacks:status` | ดูสถานะระบบทั้งหมด |
| `/dev-stacks:undo` | ย้อนกลับการเปลี่ยนแปลง |
| `/dev-stacks:learn` | จัดการ patterns |
| `/dev-stacks:doctor` | วินิจฉัยและกู้คืน |
| `/dev-stacks:help` | ดูคู่มือ |

---

## Safety Features

### Guards (ป้องกันอัตโนมัติ)

```
You: "แก้ไข .env file"

Dev-Stacks:
🛡️ Guard: BLOCKED
   File: .env
   Reason: Protected file (contains secrets)

   This file type is protected.
   Please edit manually.
```

### Undo (ย้อนกลับได้เสมอ)

```
You: "ย้อนกลับ"

Dev-Stacks:
⏪ UNDO PREVIEW
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Level: action (last change)
Action: Edit src/components/LoginForm.tsx
Time: 2 minutes ago

Changes to revert:
   - src/components/LoginForm.tsx (modified)

Proceed? [Y/n]
```

---

## Pattern Learning

### Auto-Learn

เมื่อ task สำเร็จ Dev-Stacks จะถามว่าต้องการบันทึก pattern ไหม

```
✅ Task completed successfully!

📚 Would you like to save this as a pattern?
   Pattern name: "Login Form Validation"
   [Y/n]
```

### Pattern Suggestion

เมื่อทำ task คล้ายกับ pattern ที่เคยใช้สำเร็จ

```
You: "เพิ่ม validation ในฟอร์ม register"

Dev-Stacks:
📚 Found relevant pattern:
   "Form Validation Pattern" (confidence: 0.92)
   Last used: 2 days ago | Used 3 times

   Use this pattern? [Y/n]
```

---

## Tips

### 1. พูดให้ชัดเจน

❌ "แก้ไข"
✅ "แก้ typo ใน README ตรงคำว่า 'intallation'"

### 2. ระบุ target

❌ "เพิ่ม validation"
✅ "เพิ่ม validation ในฟอร์ม login"

### 3. ให้ context (optional)

❌ "สร้าง API"
✅ "สร้าง GET /api/users/profile endpoint คล้ายกับ /api/users/me"

### 4. ใช้ภาษาที่สบายใจ

ใช้ไทย อังกฤษ หรือผสมก็ได้ ทั้งหมดเข้าใจ

---

## Troubleshooting

### Intent ผิด

```
You: "แก้ปัญหา API ช้า"
Dev-Stacks: จัดเป็น FIX_BUG แต่ควรเป็น INVESTIGATE

→ พิมพ์ "ยกเลิก" แล้วอธิบายใหม่
```

### Complexity ผิด

```
You: "เปลี่ยนสีปุ่ม"
Dev-Stacks: ใช้ Standard workflow (ซับซ้อนเกินไป)

→ พิมพ์ "ทำแบบ quick" เพื่อบังคับใช้ Quick workflow
```

### Guard กันเยอะเกินไป

```
You: "แก้ไข package.json"
Dev-Stacks: Guard ถาม confirm ทุกครั้ง

→ ใช้ `/dev-stacks:doctor` เพื่อปรับ guard settings
```

---

## Next Steps

1. **ลองใช้งาน** - เริ่มจาก task เล็กๆ เช่น แก้ typo
2. **ดู patterns** - `/dev-stacks:learn list` เพื่อดู patterns ที่เรียนรู้
3. **อ่าน help** - `/dev-stacks:help workflows` เพื่อเข้าใจ workflows
4. **ปรับแต่ง** - `/dev-stacks:doctor` เพื่อปรับ settings

---

## Examples Gallery

### แก้ Bug

```
"แก้ error Cannot read property 'id' of undefined ใน UserProfile"
"ทำให้ปุ่ม submit ทำงานเมื่อกด Enter"
"เปลี่ยนสี error message เป็นแดง"
```

### เพิ่ม Feature

```
"เพิ่ม loading spinner ตอนกดปุ่ม submit"
"เพิ่ม confirmation dialog ก่อน delete"
"สร้าง GET /api/products/search?q= endpoint"
```

### ปรับปรุง

```
"ทำให้ API response เร็วขึ้น"
"ลด bundle size ของ frontend"
"optimize database query ใน /users endpoint"
```

### สืบหา

```
"ทำไมหน้าแรกโหลดช้า?"
"หาว่า memory leak มาจากไหน"
"auth flow ทำงานยังไง?"
```
