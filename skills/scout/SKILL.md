---
name: scout
description: Use this skill when mapping the codebase before planning. Provides systematic read protocol for the scout agent.
version: 4.0.0
---

# Scout Skill

Read and map — never write.

## Protocol

1. Check onboarding: `mcp__serena__check_onboarding_performed`
2. Locate entry points with `mcp__serena__find_symbol`
3. Trace call chains with `mcp__serena__find_referencing_symbols`
4. Read all files in chain with `mcp__serena__read_file`
5. Search for related patterns with `mcp__serena__search_for_pattern`
6. Check memory for past similar work: `mcp__memory__search_nodes`
7. List project memories: `mcp__serena__list_memories`

## What to look for

- Entry points (API endpoints, event handlers, CLI commands)
- Data flow (input → transform → output)
- Dependencies (what calls what, what imports what)
- Test coverage (where are the tests for this area)
- Risk signals (legacy code, TODO, FIXME, hardcoded values)

## Output

```
SCOUT COMPLETE

Entry points:
- [file:line]: [purpose]

Call chain:
[A:line] → [B:line] → [C:line]

Affected files:
- [file]: [why affected]

Past work:
- [memory]: [relevant info] / (none)

Risks spotted:
- [risk at file:line] / (none)

Questions:
- [question if any] / (none)
```
