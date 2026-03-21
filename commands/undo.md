---
description: Revert builder changes via git — manual invocation only
allowed-tools: Bash, Read
disable-model-invocation: true
model: sonnet
---

# dev-stacks: undo

⚠️ Irreversible action — requires explicit user confirmation.

1. Read `.dev-stacks/snapshot.md` → get HEAD SHA at last checkpoint.
2. Run `git status --short` → show what will be reverted.
3. Present list and ask: **"Type YES to revert these changes."**
4. Only after receiving "YES": run `git checkout -- <file>` for each modified file.
5. Do NOT run `git reset`, `git revert`, or anything that rewrites history.
6. Report what was reverted.

If no snapshot: list modified files from `git status --short` and ask which to revert.
