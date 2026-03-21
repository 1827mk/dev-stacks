---
name: orchestrator
description: Use this skill when routing a task to the correct workflow and agents. Reads DNA and state, scores complexity, selects workflow, spawns agents in correct order.
version: 3.0.0
---

# Orchestrator Skill

Route tasks → select workflow → spawn agents → gate output.

## Step 1 — Load context

1. Read `.dev-stacks/dna.json` if exists → project name, stack, risk areas
2. Read `.dev-stacks/state.json` if exists and recent (< 30 min) → use its classification
3. Read `.dev-stacks/snapshot.md` if exists → ask user: resume or start fresh?

## Step 2 — Classify (if no valid state)

**Intent** (Thai/English):

| Intent | Keywords |
|--------|----------|
| FIX_BUG | fix, bug, error, crash, แก้, พัง, ไม่ทำงาน |
| ADD_FEATURE | add, create, implement, new, เพิ่ม, สร้าง |
| MODIFY | change, update, refactor, เปลี่ยน, ปรับ |
| EXPLAIN | explain, how, why, อธิบาย, ยังไง |
| RESEARCH | find, search, docs, หา, ค้นหา |
| DESIGN | design, architect, plan, ออกแบบ, วางแผน |
| SECURITY | security, auth, vuln, ความปลอดภัย |

**Complexity** (start 0.20, adjust):

| Condition | Delta |
|-----------|-------|
| security / payment / auth / DB migration | +0.25 |
| > 3 files affected | +0.15 |
| external API integration | +0.10 |
| ADD_FEATURE or DESIGN intent | +0.10 |
| SECURITY intent | +0.20 |
| single file, clear change | −0.10 |
| typo / comment / rename | −0.15 |
| EXPLAIN / RESEARCH intent | −0.15 |

Clamp to [0.10, 1.0].

## Step 3 — Select workflow

| Score | Workflow | Agents |
|-------|----------|--------|
| < 0.20 | quick | Claude handles directly |
| 0.20–0.39 | standard | thinker → builder |
| 0.40–0.59 | careful | thinker → builder → reviewer |
| ≥ 0.60 | full | thinker → builder → reviewer×2 parallel |

## Step 4 — Execute

### quick
Handle directly. No subagents. Output result.

### standard
1. Spawn **thinker** (uses: analyze + design skills)
2. Wait for `THINKER ANALYSIS`
3. Spawn **builder** (uses: implement skill)
4. Report `BUILDER IMPLEMENTATION` to user

### careful
1. Spawn **thinker**
2. Spawn **builder**
3. Spawn **reviewer** (uses: analyze + security skills)
4. If `NEEDS FIXES`: present issues to user, ask how to proceed
5. Report final status

### full
Same as careful + spawn two reviewers in parallel:
- Reviewer A: security focus (security skill)
- Reviewer B: correctness + production readiness (analyze skill)
Both must pass before reporting complete.

## Step 5 — Summary

```
dev-stacks: [WORKFLOW] complete
Intent: [INTENT] | Complexity: [SCORE]
Agents: [list]
Files: [from builder output]
Status: [PASSED / action needed]
```
