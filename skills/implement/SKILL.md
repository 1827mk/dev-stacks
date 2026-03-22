---
name: implement
description: Use this skill when writing or modifying code. Enforces read-first protocol and style preservation.
version: 4.0.0
---

# Implement Skill

Read first, write second — every time.

## Read-first protocol

For every file to write/edit:
1. `mcp__serena__read_file` — read the full file
2. `mcp__serena__get_symbols_overview` — understand structure
3. `mcp__serena__find_symbol` — locate exact target
4. Write — matching existing style exactly

## Style rules

- Match indent style of surrounding code
- Match error handling pattern (exceptions/Result/error codes)
- Match logging pattern
- Match import ordering
- Never add trailing whitespace or change line endings

## Scope rules

- Only modify files in the agreed plan
- New file needed? Confirm with user first
- New dependency? State name + version, wait for confirmation
- File not in plan? Raise `⚠️ SCOPE: [file] — confirm?` and stop

## Quality gates

Before finishing:
- [ ] No hardcoded secrets
- [ ] No debug/print left in production paths
- [ ] Error paths handled explicitly
- [ ] No silent catch blocks
- [ ] Names describe intent
