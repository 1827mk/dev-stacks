---
name: analyze
description: Use this skill when tracing code flow, finding root cause, mapping dependencies, or understanding impact of a change across the codebase.
version: 3.0.0
---

# Analyze Skill

Systematic codebase analysis — language-agnostic.

## Process

1. **Entry point** — locate where the feature/bug starts (API endpoint, event handler, CLI command)
2. **Trace flow** — follow the call chain using `mcp__serena__find_referencing_symbols` and `mcp__serena__find_symbol`
3. **Read files** — use `mcp__serena__read_file` on every file in the chain
4. **Map impact** — identify all files that reference the symbols being changed
5. **Cross-check memory** — `mcp__serena__list_memories` for past decisions on this area
6. **Identify unknowns** — anything not found in codebase → ask user, do not assume

## Output

```
ANALYSIS COMPLETE
Entry: [file:line]
Flow: A → B → C → D
Impact: [N] files affected
Key findings:
- [finding — file:line]
Unknowns (need user input):
- [question]
```
