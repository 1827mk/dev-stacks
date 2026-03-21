---
name: research
description: This skill should be used when the user asks to "research", "analyze codebase", "understand how", "explain architecture", "investigate", "how does X work", or when research-only workflow without implementation is needed.
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
