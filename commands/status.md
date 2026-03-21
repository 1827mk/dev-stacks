---
description: Show current dev-stacks session state — project, branch, active task, files
allowed-tools: Read, Bash
model: haiku
---

# dev-stacks: status

Read and display current state:

1. `.dev-stacks/dna.json` → project name, stack (or "not initialised")
2. `.dev-stacks/tasks.md` → active task list progress (or "no active tasks")
3. `.dev-stacks/snapshot.md` → active task from last session (or "none")
4. `git rev-parse --abbrev-ref HEAD` → branch
5. `git status --short | head -20` → modified files

Output format:
```
╔══ dev-stacks status ══════════════════════╗
  Project : [name] | [stack]
  Branch  : [branch]
  DNA     : [ready / not initialised — run /dev-stacks:registry]
  ─────────────────────────────────────────
  Tasks   : [N done / N total] or "none"
  Snapshot: [timestamp] or "none"
  ─────────────────────────────────────────
  Modified: [N files]
  [file list — max 10]
╚═══════════════════════════════════════════╝
```
