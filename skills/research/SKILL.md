---
name: research
description: Research-only workflow. Spawns thinker subagent for analysis without implementation.
---

# Dev-Stacks Research

Research and analysis only. No code changes.

## Use When

- Understanding codebase
- Researching best practices
- Evaluating approaches
- Documentation review
- "How does X work?"

## Process

1. Read state.json
2. Spawn thinker subagent with research focus
3. Return findings to main context

## Output

```
RESEARCH COMPLETE

Key Findings:
- [finding 1]
- [finding 2]

Relevant Code:
- [file]: [what]

Recommendations:
- [recommendation]

Docs: [links if any]
```
