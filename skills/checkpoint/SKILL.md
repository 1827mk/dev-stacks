---
name: checkpoint
description: Use this skill to save current working state mid-task. Writes snapshot.md so work survives context compaction or session restart.
version: 3.0.0
---

# Checkpoint Skill

Save working state → survive context compaction.

## Process

1. Collect from context (do not re-scan):
   - Original task prompt
   - Thinker plan (verbatim — do not summarise)
   - Files changed so far
   - Files remaining from plan
   - Decisions made, open questions

2. Run via Bash:
   ```
   git rev-parse HEAD
   git rev-parse --abbrev-ref HEAD
   git status --short
   ```

3. Write `.dev-stacks/snapshot.md`:
```markdown
# dev-stacks snapshot — <timestamp>

## Task
<prompt verbatim>

## Plan
<thinker output verbatim or "(none)">

## Progress
Done:
- [file:lines]: [what]
Remaining:
- [step N]: [file]

## Git
HEAD: <SHA>
Branch: <branch>
Modified: <git status>

## Decisions
- <decision>

## Open questions
<question or "(none)">

## On restore
1. Read this before anything.
2. Confirm remaining steps with user.
3. Do NOT redo completed steps.
4. If HEAD changed: git diff <SHA> HEAD
```

4. `mcp__serena__write_memory` key `dev-stacks/checkpoint` — copy snapshot content.

5. Confirm to user:
```
Checkpoint saved → .dev-stacks/snapshot.md
Remaining: [N steps]
HEAD: [SHA]
```
