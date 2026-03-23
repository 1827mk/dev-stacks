---
name: checkpoint
description: Save current state mid-task. Writes to task directory for persistence.
version: 4.1.0
---

# Checkpoint Skill

## Process

1. Get Task ID from `.dev-stacks/snapshot.md`
2. Collect from context:
   - Original task prompt
   - Architect plan
   - Files changed + remaining
   - Decisions made

3. Write to `.dev-stacks/tasks/{task-id}/snapshot.md`:
```markdown
# Checkpoint — <ISO>
Task ID: <task-id>

## Phase
<current phase>

## Progress
Done: [file:lines - what]
Remaining: [step N - file]

## Git
HEAD: <SHA> | Branch: <branch>
Modified: <git status>

## Decisions
- <decision>

## Next
<next step>
```

4. Update `.dev-stacks/snapshot.md` with latest status

5. Confirm:
```
Checkpoint → tasks/{task-id}/snapshot.md
Phase: [N] | Remaining: [N steps]
```
