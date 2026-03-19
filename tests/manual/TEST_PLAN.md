# Dev-Stacks Team System - Manual Test Plan

**Version:** 1.0.0
**Prerequisites:** Restart Claude Code session to reload plugin

---

## Test Matrix

| # | Scenario | Workflow | Agents | Status |
|---|----------|----------|--------|--------|
| 1 | Quick: Fix typo | Quick | Builder | ⬜ |
| 2 | Standard: Add log | Standard | Thinker → Builder | ⬜ |
| 3 | Careful: Create API | Careful | Thinker → Builder → Tester | ⬜ |
| 4 | Full: Payment feature | Full | Thinker → Builder → Tester | ⬜ |
| 5 | Error recovery | Error | Ask user | ⬜ |
| 6 | Cancel flow | Cancel | Return to IDLE | ⬜ |
| 7 | State persistence | Recovery | Resume | ⬜ |

---

## Scenario 1: Quick Workflow

**Input:** `แก้ typo ใน README`

**Expected:**
- Routing shows Quick workflow
- No Thinker dispatched
- Builder implements fix directly

---

## Scenario 2: Standard Workflow

**Input:** `เพิ่ม console.log ใน function main`

**Expected:**
- Thinker plans
- User confirms
- Builder implements

---

## Scenario 3-7: See automated tests

---

## Post-Test Checklist

- [ ] All 7 scenarios pass
- [ ] No unexpected errors
- [ ] Production-ready output
