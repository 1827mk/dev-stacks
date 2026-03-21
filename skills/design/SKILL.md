---
name: design
description: Use this skill when creating architecture plans, designing interfaces, data models, or making structural decisions before implementation.
version: 3.0.0
---

# Design Skill

Technical design — language-agnostic, pattern-driven.

## Process

1. **Understand constraints** — read existing patterns from codebase, do not fight the architecture
2. **Check library docs** — use `mcp__context7__get-library-docs` if integrating external tools
3. **Design interface first** — define inputs/outputs/contracts before internals
4. **Consider failure modes** — what breaks? what needs rollback? what needs idempotency?
5. **Minimal change principle** — prefer extending over rewriting, prefer composition over inheritance
6. **Ask before deciding** — if two approaches are valid, present both and ask user which to use

## Output

```
DESIGN COMPLETE
Approach: [chosen pattern and why]
Interface:
  Input:  [type/schema]
  Output: [type/schema]
  Errors: [error cases]
Files to create/modify:
- [path]: [purpose]
Alternatives considered:
- [option]: [why not chosen]
Questions for user:
- [question]
```
