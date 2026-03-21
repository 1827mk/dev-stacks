---
name: implement
description: This skill should be used when the user asks to "implement", "build", "just do it", "skip planning", "direct implementation", or when implementation-only workflow without planning phase is needed.
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
