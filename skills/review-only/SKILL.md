---
name: review-only
description: Use this skill when the user runs /dev-stacks:review or wants to verify existing code without making changes. Spawns reviewer only.
version: 3.0.0
---

# dev-stacks review-only

Verification only — no implementation, no planning.

## Use when
- Code already written, need quality check
- Pre-commit verification
- "ตรวจสอบ code" / "review my changes"

## Process
1. Run `git diff --name-only HEAD` and `git diff --cached --name-only` to identify changed files.
2. Pass file list to **reviewer** agent.
3. Pass thinker plan from `.dev-stacks/snapshot.md` if available (for plan-alignment check).
4. Report `REVIEWER VERIFICATION` to user.

## If reviewer returns FAILED
Present the required fixes to user and ask: "Fix now with `/dev-stacks:implement`?"
