---
name: scout
description: Map codebase before planning — read-only, targeted reads only.
version: 4.1.0
---

# Scout Skill

Read and map — never write. **Be targeted, not exhaustive.**

## Protocol (MINIMIZE tool calls)

1. Check onboarding: `mcp__serena__check_onboarding_performed`
2. **Find ONLY directly relevant symbols** — not the whole codebase
3. Read **max 5 files** — the most relevant ones
4. Check memory for past work: `mcp__memory__search_nodes`
5. **Write output to `.dev-stacks/scout-output.md`** for next agent

## Targeted Reading Rules

- ❌ Don't list entire directories
- ❌ Don't search for patterns without specific target
- ❌ Don't trace entire call chains — just entry points
- ✅ Read only files directly mentioned in task
- ✅ Use `find_symbol` with specific names
- ✅ Stop after finding what's needed

## Output (write to `.dev-stacks/scout-output.md`)

```
SCOUT COMPLETE
Entry: [file:line - purpose]
Chain: [A]→[B]→[C] (key files only)
Files: [file: why]
Past: [memory]/(none)
Risks: [risk]/(none)
```
