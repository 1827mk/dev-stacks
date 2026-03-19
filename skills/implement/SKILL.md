---
name: implement
description: Implementation-only workflow. Skips planning, goes straight to building.
---

# Dev-Stacks Implement

Direct implementation without planning phase.

## Use When

- Plan already exists
- Simple, clear task
- Following established patterns
- "Just do it"

## Process

1. Read state.json
2. Spawn builder subagent
3. Return changes to main context

## Output

```
BUILDER: Implemented [task]
Files:
- [file]: [change]

Done. [summary]
```
