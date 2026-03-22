---
name: checkpoint
description: Use this skill to save current working state mid-task. Writes .dev-stacks/snapshot.md so work survives context compaction or session restart.
version: 4.0.0
---

# Checkpoint Skill

## Process

1. Collect from context (do not re-scan):
   - Original task prompt
   - Architect plan verbatim (never summarise)
   - Files changed so far + files remaining
   - Decisions made, open questions

2. Run via Bash:
   - `git rev-parse HEAD`
   - `git rev-parse --abbrev-ref HEAD`
   - `git status --short`

3. Write `.dev-stacks/snapshot.md`:

```markdown
# dev-stacks snapshot — <ISO>

## Task
<prompt verbatim>

## Phase
<current phase>

## Plan
<architect plan verbatim or "(none)">

## Progress
Done:
- [file:lines]: [what]
Remaining:
- [step N]: [file]

## Git
HEAD: <SHA> | Branch: <branch>
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

4. Write to `mcp__serena__write_memory` key `dev-stacks/checkpoint`

5. Confirm:
```
Checkpoint saved → .dev-stacks/snapshot.md
Remaining: [N steps] | HEAD: [SHA]
```
