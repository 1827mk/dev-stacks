---
name: orchestrator
description: Route task through workflow. Core of /dev-stacks:do.
version: 4.3.0
---

# Orchestrator — Optimized Workflow

## Step 1 — Classify

**Intent**: FIX(fix,bug,แก้) | ADD(add,new,เพิ่ม) | MODIFY(change,เปลี่ยน) | EXPLAIN(how,why,อธิบาย) | RESEARCH(find,หา)

**Complexity** (start 0.25, clamp [0.10, 1.0]):
- security/auth: +0.30
- >3 files: +0.10
- ADD/MODIFY: +0.05
- single file: -0.10
- typo/comment: -0.20
- EXPLAIN/RESEARCH: -0.20

## Step 2 — Select

| Score | Workflow | Agents |
|-------|----------|--------|
| <0.30 | quick | none |
| 0.30-0.50 | standard | scout→architect→builder |
| 0.50-0.70 | careful | +verifier→sentinel |
| ≥0.70 | full | +chronicler |

## Step 3 — Task ID

**Generate unique task ID:**
```
TASK_ID=$(date +%Y%m%d-%H%M%S)_$(echo $RANDOM | head -c 4)
```

**Create task directory:**
```
.dev-stacks/tasks/{TASK_ID}/
├── scout-output.md
├── plan.md
├── snapshot.md
└── changes.log
```

## Step 4 — Execute

**Each agent writes to task directory:**
1. Scout → `tasks/{id}/scout-output.md`
2. Architect → `tasks/{id}/plan.md`
3. Builder → logs changes to `tasks/{id}/changes.log`

**Read from task directory, NOT conversation:**
- Architect reads: `tasks/{id}/scout-output.md`
- Builder reads: `tasks/{id}/plan.md`

## Step 5 — Summary

```
dev-stacks: [WORKFLOW] complete
Task ID: [TASK_ID]
Files: [list]
```

## Multi-Task Handling

If user starts new task while one is active:
1. Check `.dev-stacks/snapshot.md` for active task
2. Ask: "Resume [task-id] or start fresh?"
3. If fresh → create new task directory
4. If resume → use existing task directory
