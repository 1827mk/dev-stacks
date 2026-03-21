---
description: Show current dev-stacks session state
allowed-tools: Read, Bash
model: haiku
---

# dev-stacks: status

Read and display:
1. `.dev-stacks/dna.json` → project name, stack, risk areas (or "DNA not initialised — run /dev-stacks:init")
2. `.dev-stacks/snapshot.md` → active task, progress, remaining steps (or "No active task")
3. `git rev-parse --abbrev-ref HEAD` → current branch
4. `git status --short` → modified files (max 20 lines)

Output as compact block:
```
dev-stacks status
────────────────
Project: [name] | Stack: [langs]
Branch:  [branch]
Task:    [task or "none"]
Files:   [modified count]
DNA:     [ready / not initialised]
Snapshot:[timestamp or "none"]
────────────────
```
