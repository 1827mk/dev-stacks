---
name: research
description: Use this skill when the user runs /dev-stacks:research or asks to understand/explore/explain without implementing. Spawns thinker only — no code changes.
version: 3.0.0
---

# dev-stacks research

Research and analysis only. No implementation, no code changes.

## Use when
- Understanding how existing code works
- Researching best practices or library docs
- Evaluating approaches before committing
- Answering "how does X work?" or "อธิบาย X"

## Process
1. Spawn **thinker** agent with research focus.
2. Wait for `THINKER ANALYSIS`.
3. Return findings to user — no builder spawned.

## Output to user
```
RESEARCH COMPLETE

Key findings:
- [finding — file:line]

Relevant code:
- [file]: [what it does]

Recommendations:
- [approach or next step]
```
