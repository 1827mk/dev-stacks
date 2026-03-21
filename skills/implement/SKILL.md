---
name: implement
description: Use this skill when writing or modifying code. Provides read-first protocol, style preservation rules, and scope boundaries for any language or framework.
version: 3.0.0
---

# Implement Skill

Production-quality code implementation — language-agnostic.

## Read before write — always

Before touching any file:
1. Read the entire file with `mcp__serena__read_file`
2. Get symbol overview with `mcp__serena__get_symbols_overview`
3. Find the exact target with `mcp__serena__find_symbol`
4. Only then write

## Style rules — preserve existing patterns

- Match the indent style, spacing, and naming of surrounding code
- Match the error handling style (checked exceptions / Result types / error codes)
- Match the logging pattern (structured JSON / SLF4J / fmt.Errorf / console.log)
- Match import ordering and grouping
- Never add trailing whitespace or change line endings

## Scope rules

- Only modify files in the agreed plan
- New file needed? Confirm with user first
- New dependency needed? State name + version and wait for confirmation
- Something unclear? Ask before writing — never guess

## Quality gates before finishing

- [ ] No hardcoded secrets, tokens, or passwords
- [ ] No debug/test code left in production paths
- [ ] Error paths handled explicitly
- [ ] No silent catch blocks
- [ ] Variable/function names describe intent
