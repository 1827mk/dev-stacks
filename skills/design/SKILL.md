---
name: design
description: Use this skill when designing technical approach, architecture, or interface contracts.
version: 4.0.0
---

# Design Skill

Think before building — language-agnostic.

## Protocol

1. Use `mcp__sequentialthinking__sequentialthinking` to reason through the approach
2. Check `mcp__context7__get-library-docs` for any library involved
3. Search `mcp__memory__search_nodes` for past architectural decisions
4. If two valid approaches exist → present both, ask user to choose
5. If web research needed → ask user for permission first

## Principles

- Prefer extending over rewriting
- Prefer composition over inheritance
- Design interface first (inputs/outputs/errors), then internals
- Consider failure modes before happy path
- Minimal surface area — only expose what's needed

## Output

```
DESIGN COMPLETE

Approach: [chosen pattern + rationale]
Interface:
  Input:  [type/schema]
  Output: [type/schema]
  Errors: [error cases]

Steps:
1. [file, function, change]
2. ...

Alternatives considered:
- [option]: [why not chosen]

Questions for user:
- [question] / (none)
```
