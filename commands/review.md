---
description: Run reviewer agent on current git changes
allowed-tools: Read, Glob, Grep, LS, Bash, mcp__serena__find_symbol, mcp__serena__read_file, mcp__serena__get_symbols_overview, mcp__serena__search_for_pattern, mcp__serena__read_memory
model: sonnet
---

# dev-stacks: review

1. Run `git diff --name-only HEAD` and `git diff --cached --name-only` — list changed files.
2. Load thinker plan from `.dev-stacks/snapshot.md` if it exists.
3. Spawn **reviewer** agent with the changed files and plan as context.
4. Report `REVIEWER VERIFICATION` output to user.
5. If `Result: FAILED`, ask: "Fix with `/dev-stacks:run`?"
