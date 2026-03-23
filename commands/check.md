---
description: Run verifier + sentinel independently on current changes — no build, just check
argument-hint: [optional: files or scope to check]
allowed-tools: Read, Glob, Grep, LS, Bash, mcp__serena__read_file, mcp__serena__find_symbol, mcp__serena__search_for_pattern, mcp__memory__search_nodes
model: sonnet
---

# dev-stacks: check

Run quality and security checks on current changes.

## Steps

1. Get changed files:
   ```
   git diff --name-only HEAD
   git diff --cached --name-only
   ```

2. Load thinker plan from `.dev-stacks/plan.md` if exists (for plan-alignment check)

3. Spawn **verifier** agent — run tests, reflection loop up to 3 cycles

4. Spawn **sentinel** agent — security review of changed files

5. Spawn **handoff-verify** (fresh agent in clean context) — second opinion on correctness

6. Present combined results. If any CRITICAL issues:
   - Show exactly what must be fixed
   - Ask user: "Fix now or handle manually?"
