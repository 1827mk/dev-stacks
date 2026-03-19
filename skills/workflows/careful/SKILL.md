---
name: careful
description: Careful workflow for security-sensitive tasks (complexity 0.4-0.59). Full team + user confirmation.
---

# Careful Workflow

Security-sensitive and complex tasks requiring verification.

## When to Use
- Complexity: 0.4 - 0.59
- Security changes
- Data handling
- Multiple components

## Team
```
Thinker → CONFIRM → Builder → Tester
```

## Process
```
User Input → Thinker → Show Plan → User Approval → Builder → Tester → Done
```

## Steps

1. **Thinker**: Analyze, research, plan, identify risks
2. **Confirm**: Show plan, get user approval
3. **Builder**: Implement following plan
4. **Tester**: Verify implementation, run tests

## Confirmation Format

```
PLAN READY
Task: [description]
Files: [list]
Approach: [summary]
Risks: [list]

Proceed? (yes/modify/cancel)
```

## Output Format

```
CAREFUL WORKFLOW
Task: [description]

THINKER:
Plan: [steps]
Risks: [list]

[User approved]

BUILDER:
Changes: [list]

TESTER:
Verification: [results]
Tests: [pass/fail]

Done. [summary]
```

## Error Recovery

| Error | Action |
|-------|--------|
| Recoverable | Auto-fix |
| Planning error | Return to Thinker (max 2x) |
| Test failure | Return to Builder |
| Blocking | Ask user |

## Rollback
Use `/dev-stacks:undo` for checkpoint rollback.

## Time
- Target: 2-4 minutes
- Max: 8 minutes
