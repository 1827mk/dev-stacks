---
name: team-selector
description: Select agents based on complexity. Auto-invoked after complexity scoring.
---

# Team Selector

Select agents based on workflow.

## Selection Logic

```
team = ["builder"]  # Always
if complexity >= 0.2: team.append("thinker")
if complexity >= 0.4: team.append("tester")
```

## Workflow → Team

| Workflow | Complexity | Team |
|----------|------------|------|
| QUICK | <0.2 | [Builder] |
| STANDARD | 0.2-0.39 | [Thinker, Builder] |
| CAREFUL | 0.4-0.59 | [Thinker, Builder, Tester] |
| FULL | >=0.6 | [Thinker, Builder, Tester] + Confirm |

## Agent Roles

| Agent | Role | When |
|-------|------|------|
| Thinker | Plan, analyze | complexity >= 0.2 |
| Builder | Implement | Always |
| Tester | Verify | complexity >= 0.4 |

## Research

All agents can use: context7, web_reader, WebSearch, fetch, memory
