---
name: checkpoint
description: Use this skill when the user runs /dev-stacks:checkpoint, or when a long task needs a mid-session save before context degrades. Writes .dev-stacks/snapshot.md.
version: 3.0.0
---

# dev-stacks checkpoint

Save current working state so it survives context compaction or session restart.

## When to trigger
- User types `/dev-stacks:checkpoint`
- Thinker plan produced but builder not started
- Builder completed 2+ file changes with more remaining
- Context is getting large

## Process

### 1. Collect from context (do not re-scan)
- Original task description
- Thinker plan verbatim (if produced)
- Files changed so far (from BUILDER IMPLEMENTATION sections)
- Files remaining (from plan minus done)
- Decisions made, open challenges

### 2. Collect from filesystem
Run `Bash`: `git -C "$CLAUDE_PROJECT_DIR" rev-parse HEAD` → HEAD SHA
Run `Bash`: `git -C "$CLAUDE_PROJECT_DIR" rev-parse --abbrev-ref HEAD` → branch
Run `Bash`: `git -C "$CLAUDE_PROJECT_DIR" status --short` → modified files

### 3. Write snapshot
Overwrite `.dev-stacks/snapshot.md`:

```markdown
# dev-stacks checkpoint — <ISO timestamp>

## Task
<original prompt verbatim>

## Intent / workflow
Intent: <INTENT>
Workflow: <quick|standard|careful|full>

## Plan (thinker output)
<paste verbatim or "(none)">

## Progress
Done:
- <file:line-range>: <what was done>

Remaining:
- <step N>: <file>

## Git state
HEAD: <SHA>
Branch: <branch>
Modified:
<git status output>

## Decisions
- <decision>

## Open challenges
<challenge text or "(none)">

## On restore
1. Read this snapshot before anything.
2. Confirm remaining steps with user before continuing.
3. Do NOT re-run steps listed under Done.
4. If HEAD SHA changed, run: git diff <SHA> HEAD
```

### 4. Save to serena memory
Call `mcp__serena__write_memory` with key `dev-stacks/checkpoint` — copy the snapshot content.

### 5. Confirm
```
Checkpoint saved → .dev-stacks/snapshot.md + serena memory
Remaining steps: [N]
Git HEAD: [SHA]
Resume: /dev-stacks:run
```

**Rule**: Copy thinker plan verbatim — do not summarise.
