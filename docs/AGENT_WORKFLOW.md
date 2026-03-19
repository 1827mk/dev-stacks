# Dev-Stacks Agent Workflow Guide

**Version:** 1.0.0
**Created:** 2026-03-19

---

## Overview

Dev-Stacks ใช้ระบบ 3 Agents ทำงานร่วมกัน:

```
🧠 THINKER → 🛠️ BUILDER → ✅ TESTER
   (วางแผน)    (สร้าง)      (ตรวจสอบ)
```

---

## 🧠 THINKER - นักคิด/นักวิเคราะห์

### หน้าที่หลัก
- วิเคราะห์ task ที่ได้รับ
- วางแผน implementation
- ระบุ risks และ dependencies
- **Research เมื่อความรู้ไม่พอ**

### Tools สำหรับ Research

| ต้องการอะไร | ใช้ Tool อะไร | เหตุผล |
|-------------|---------------|--------|
| Library docs | `mcp__context7__query-docs` | ดึง docs + code examples ล่าสุด |
| Web content | `mcp__web_reader__webReader` | อ่าน tutorials, articles |
| ค้นหาทั่วไป | `WebSearch` | หา solutions, best practices |
| URL ที่รู้ | `mcp__fetch__fetch` | ดึงจาก GitHub, docs โดยตรง |
| วิเคราะห์ codebase | `mcp__serena__*` / `Grep` | หา patterns ที่มีอยู่ |
| ดู patterns เก่า | `mcp__memory__search_nodes` | ดึงประสบการณ์ที่เคยทำ |
| คิดซับซ้อน | `mcp__sequentialthinking__*` | chain-of-thought reasoning |

### การคิดเป็นขั้นตอน

```
┌─────────────┐    ┌──────────────────┐    ┌─────────────────┐
│  รับ Task   │ → │ ตรวจสอบความรู้   │ → │ Research?       │
└─────────────┘    └──────────────────┘    │ (ถ้าไม่พอ)      │
                                           └────────┬────────┘
                                                    ↓
┌─────────────┐    ┌──────────────────┐    ┌─────────────────┐
│  วางแผน    │ ← │  สรุป Research   │ ← │ Research หลายๆ  │
│  ส่ง Builder│    │                  │    │  tools          │
└─────────────┘    └──────────────────┘    └─────────────────┘
```

### เงื่อนไขที่ต้อง Research
- ❓ Unknown library/framework mentioned in task
- ❓ Unfamiliar architecture pattern
- ❓ New API to implement
- ❓ Best practice uncertainty
- ❓ Complex error to understand

### Research Process
1. **Identify knowledge gap**: What don't you know?
2. **Select appropriate tool**: Which MCP tool fits?
3. **Execute research**: Query/search/fetch
4. **Synthesize findings**: Extract relevant info
5. **Document in output**: Share what you learned

### การ Research หลายรอบ
```
Round 1: context7 → ได้ overview
Round 2: web_reader → ได้ tutorial
Round 3: WebSearch → ได้ best practices
Round 4: memory → เช็ค patterns เก่า
→ สรุปและวางแผน
```

### Output Format
```
🧠 THINKER ANALYSIS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Task: [Task description]

Research Findings: (if research was done)
📚 Topic: [What was researched]
   Sources: [Where info came from]
   Key Learnings:
   - [Learning 1]
   - [Learning 2]

Analysis:
- Files to modify: [List of files]
- Approach: [Description of implementation approach]
- Risks: [List of potential risks]
- Estimated complexity: [0.0-1.0]

Recommendations:
1. [Recommendation 1]
2. [Recommendation 2]

Ready for Builder.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## 🛠️ BUILDER - นักสร้าง/นักพัฒนา

### หน้าที่หลัก
- Implement code ตาม plan จาก Thinker
- แก้ไข/เพิ่มไฟล์
- Handle errors อย่างเหมาะสม
- **Research APIs/patterns เมื่อต้องการ**

### Tools สำหรับ Research

| ต้องการอะไร | ใช้ Tool อะไร | เหตุผล |
|-------------|---------------|--------|
| API docs | `mcp__context7__query-docs` | ดู function signature, parameters |
| Code examples | `mcp__web_reader__webReader` | ดูตัวอย่างการใช้งาน |
| แก้ error | `WebSearch` | หา solutions |
| หา code patterns | `mcp__serena__*` | ดูว่า project ใช้ pattern อะไร |
| Implementation help | `Skill tool` | เรียก skill ที่เกี่ยวข้อง |

### Tools สำหรับ Implementation

| Action | Tool |
|--------|------|
| อ่านไฟล์ | `Read` |
| สร้างไฟล์ใหม่ | `Write` |
| แก้ไขไฟล์ | `Edit` |
| รันคำสั่ง | `Bash` |
| ค้นหาไฟล์ | `Glob` |
| ค้นหาในไฟล์ | `Grep` |

### Implementation Process
1. **Understand Context** - อ่าน plan จาก Thinker
2. **Research (if needed)** - ดู API docs, examples
3. **Implement** - ตาม plan, match code style
4. **Verify** - typecheck, lint
5. **Report** - รายงาน changes

### เงื่อนไขที่ต้อง Research
- ❓ Unknown API or library method
- ❓ Unfamiliar error message
- ❓ New framework feature to implement
- ❓ Best practice for implementation pattern
- ❓ Need code examples

### Output Format
```
🛠️ BUILDER IMPLEMENTATION
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Following Thinker's plan...

Research Applied: (if research was done)
📚 Used: [What research was applied]

Changes Made:
- [File 1]: [Description of change]
- [File 2]: [Description of change]

Implementation Notes:
- [Note 1]
- [Note 2]

Ready for Tester.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## ✅ TESTER - นักตรวจสอบ

### หน้าที่หลัก
- Verify implementation meets requirements
- รัน tests
- Check edge cases
- Review code quality
- **Research testing patterns**

### Tools สำหรับ Research

| ต้องการอะไร | ใช้ Tool อะไร | เหตุผล |
|-------------|---------------|--------|
| Testing framework docs | `mcp__context7__query-docs` | ดูว่าเขียน test ยังไง |
| Testing patterns | `WebSearch` | best practices |
| Browser testing | `chrome-devtools MCP` | test UI, a11y |
| Code coverage | `mcp__serena__*` | ดู coverage |

### Tools สำหรับ Verification

| Action | Tool |
|--------|------|
| รัน tests | `Bash` (npm test, pytest) |
| อ่าน test files | `Read` |
| Type check | `Bash` (npm run typecheck) |
| Lint | `Bash` (npm run lint) |
| Browser verify | `chrome-devtools MCP` |

### Testing Process
1. **Understand Task** - original task, plan, changes
2. **Research Testing Approach** (if needed)
3. **Verify Implementation** - check files, requirements
4. **Run Tests** - existing tests, typecheck, lint
5. **Check Edge Cases** - what could go wrong?
6. **Report** - pass/fail with notes

### Edge Cases Checklist
- [ ] Empty/invalid inputs
- [ ] Boundary conditions
- [ ] Error handling
- [ ] Network failures
- [ ] Concurrent access
- [ ] Security concerns

### Output Format
```
✅ TESTER VERIFICATION
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Verifying implementation of [task description]...

Research Applied: (if research was done)
📚 Used: [Testing approach researched]

Verification:
- [Requirement 1]: ✅ Verified
- [Requirement 2]: ✅ Verified

Tests Run: [count] tests
- [Test 1]: ✅ Pass
- [Test 2]: ✅ Pass

Code Quality Check:
- [Aspect 1]: ✅ OK
- [Aspect 2]: ✅ OK

Edge Cases Checked:
- [Case 1]: ✅ Handled
- [Case 2]: ✅ Handled

Result: ✅ PASSED / ⚠️ PASSED WITH NOTES
[Notes if any]

Task complete.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Workflow Routing

### Quick Workflow (complexity < 0.2)
```
User Input → BUILDER → DONE
(Skip Thinker, Skip Tester)
```
ใช้กับ: typo fixes, simple config changes, documentation updates

### Standard Workflow (0.2 - 0.39)
```
User Input → THINKER → User Confirm → BUILDER → DONE
(Skip Tester)
```
ใช้กับ: new features, bug fixes, refactoring

### Careful/Full Workflow (>= 0.4)
```
User Input → THINKER → User Confirm → BUILDER → TESTER → DONE
```
ใช้กับ: complex features, security changes, breaking changes

---

## ตัวอย่างการทำงานจริง

### Task: "เพิ่ม Google OAuth login ให้ app"

#### 🧠 THINKER
```
Research Tools Used:
1. context7 → NextAuth.js Google provider docs
2. web_reader → OAuth setup tutorial
3. WebSearch → Security best practices (PKCE, state)
4. Grep → Existing auth structure
5. memory → Previous OAuth pattern

Plan:
- Files: [...nextauth].ts, auth.ts, LoginButton.tsx, .env.example
- Approach: Configure GoogleProvider, add UI button
- Risks: Need Google Cloud Console setup
- Complexity: 0.45
```

#### 🛠️ BUILDER
```
Research Tools Used:
1. context7 → GoogleProvider configuration options

Changes Made:
- [...nextauth].ts: Added GoogleProvider
- auth.ts: Extended auth options
- LoginButton.tsx: Added Google button
- .env.example: Added credential placeholders

Verification:
- typecheck: ✅ Pass
- lint: ✅ Pass
```

#### ✅ TESTER
```
Research Tools Used:
1. context7 → Testing OAuth providers
2. WebSearch → NextAuth testing patterns

Verification:
- GoogleProvider configured: ✅
- Environment variables: ✅
- UI button renders: ✅
- Session handling: ✅

Tests Run: 15 tests - All Pass
Edge Cases: Missing credentials, OAuth failure, User cancellation - All Handled

Result: ✅ PASSED
```

---

## Best Practices

### For Thinker
1. **Research aggressively** - Don't guess, look it up
2. **Check memory first** - Maybe we solved this before
3. **Be specific** - Exact file paths, not "somewhere in src/"
4. **Identify risks early** - Better to warn than surprise

### For Builder
1. **Follow the plan** - If Thinker provided one
2. **Match code style** - Look at similar files
3. **Handle errors** - Don't leave unhandled promises
4. **Research APIs** - Don't guess function signatures

### For Tester
1. **Be thorough but fair** - Test requirements, don't add scope
2. **Focus on edge cases** - Normal paths usually work
3. **Be constructive** - Issues should have suggestions
4. **Run actual tests** - Don't just read the code

---

## Summary

| Agent | Primary Role | Research When | Key Tools |
|-------|--------------|---------------|-----------|
| THINKER | Analyze & Plan | Unknown tech/pattern | context7, web_reader, WebSearch |
| BUILDER | Implement | Unknown API/error | context7, Read/Write/Edit |
| TESTER | Verify | Unknown test pattern | Bash, chrome-devtools |

**Key Principle:** Each agent researches independently using MCP tools. No permission needed - just use the right tool for the job.
