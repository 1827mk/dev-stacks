---
name: orchestrator
description: Use this skill when routing a task to the correct dev-stacks workflow. Triggered by /dev-stacks:run or when complexity needs assessment before spawning agents.
version: 3.0.0
---

# dev-stacks orchestrator

Route the current task to the correct workflow, then execute it.

## Step 1 — Load context

Read in order (stop when found):
1. `.dev-stacks/snapshot.md` — if exists and has an unfinished task, ask user: resume or start fresh?
2. `.dev-stacks/state.json` — get `task.intent`, `task.complexity`, `workflow.type`.
3. `.dev-stacks/dna.json` — load as codebase context for agents.

If none exist: classify from the current prompt directly (skip to Step 2).

## Step 2 — Verify or re-classify

If state.json exists and timestamp < 30 min: use its classification.
Otherwise classify the current prompt:

| Intent | Thai / English keywords |
|--------|------------------------|
| FIX_BUG | แก้ bug / fix / error / crash / exception / ไม่ทำงาน |
| ADD_FEATURE | เพิ่ม / add / create / implement / new feature / สร้าง |
| MODIFY | เปลี่ยน / change / update / refactor / ปรับ |
| EXPLAIN | อธิบาย / explain / how / what / why |
| RESEARCH | หา / find / search / lookup / docs |
| TEST | ทดสอบ / test / verify / spec |
| COMMIT | commit / push / PR / merge |

Complexity scoring (start at 0.2, adjust):

| Condition | Delta |
|-----------|-------|
| Affects security / auth / payment / DB migration | +0.25 |
| Affects > 3 files | +0.15 |
| External API / library integration | +0.10 |
| Single-file clear change | −0.10 |
| Typo / rename / comment | −0.15 |
| FIX_BUG intent | +0.05 |
| ADD_FEATURE intent | +0.10 |
| EXPLAIN / RESEARCH / COMMIT intent | −0.15 |

Clamp to [0.1, 1.0].

## Step 3 — Select and execute workflow

| Score | Workflow | Sequence |
|-------|----------|----------|
| < 0.20 | **quick** | Handle directly — no agents |
| 0.20–0.39 | **standard** | thinker → builder |
| 0.40–0.59 | **careful** | thinker → builder → reviewer |
| ≥ 0.60 | **full** | thinker → builder → reviewer (×2 parallel: security + correctness) |

### quick
Handle directly. Output result. No subagents.

### standard
1. Spawn **thinker** with the task.
2. Wait for `THINKER ANALYSIS`.
3. Spawn **builder** with thinker's plan in context.
4. Report `BUILDER IMPLEMENTATION` summary to user.

### careful
1. Spawn **thinker**.
2. Wait for `THINKER ANALYSIS`.
3. Spawn **builder**.
4. Wait for `BUILDER IMPLEMENTATION`.
5. Spawn **reviewer**.
6. If reviewer outputs `Result: FAILED`: spawn **builder** again with reviewer's required fixes, then re-run reviewer.
7. Report final status.

### full
Same as careful, but at step 5 spawn **two reviewer agents in parallel**:
- Reviewer A: focus on security (auth, input validation, secrets).
- Reviewer B: focus on correctness and enterprise constraints.
Both must return `Result: PASSED` before work is complete.

## Step 4 — Summary to user

```
dev-stacks: [WORKFLOW] complete
Intent: [INTENT] | Complexity: [SCORE]
Agents: [list]
Files changed: [from builder output]
Status: PASSED / needs action
```
