---
name: verify-loop
description: Use this skill to run tests and iterate on failures — reflection loop up to 3 cycles before escalating to user.
version: 4.0.0
---

# Verify-Loop Skill

Run → read error → fix → repeat. Max 3 cycles.

## Step 1 — Find test command

From `.dev-stacks/dna.json` → `project.build_tool`:
- Maven: `mvn test`
- Gradle: `./gradlew test`
- npm: `npm test`
- Go: `go test ./...`
- Python: `pytest`
- Unknown → ask user before starting

## Step 2 — Reflection loop

```
Cycle N:
  1. Run command with Bash
  2. Read FULL output
  3. PASS → done
  4. FAIL → extract error + file:line → minimal fix → Cycle N+1
  5. After cycle 3 → ESCALATE
```

## Step 3 — Escalate

```
VERIFY LOOP — 3 cycles, still failing

Cycle 1: [error summary]
Cycle 2: [error summary]
Cycle 3: [error summary]

Current error:
[full text]

Options:
1. Tell me what to try
2. Skip this test
3. Show the failing code
```

Always ask — never decide alone.
