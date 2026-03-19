---
name: full
description: Full workflow for critical tasks (complexity >=0.6). Full team + 2 user confirmations + rollback plan.
---

# Full Workflow

Critical, high-risk tasks requiring maximum caution.

## When to Use
- Complexity: 0.6 - 1.0
- Payment processing
- Auth system changes
- Database schema changes
- Security modifications

## Team
```
Thinker → CONFIRM → Builder → Tester → FINAL REVIEW
```

## Process
```
User Input → Thinker (deep analysis + risks + rollback plan)
          → Show Plan → User Approval #1
          → Builder → Tester
          → Show Results → User Approval #2
          → Done
```

## Steps

1. **Thinker**: Deep analysis, research, full plan, risk assessment, rollback plan
2. **Confirm #1**: Show plan + risks + rollback, get approval
3. **Builder**: Careful implementation
4. **Tester**: Full verification
5. **Confirm #2**: Show changes + test results, get final approval

## Confirmation Format

```
CRITICAL TASK - CONFIRMATION REQUIRED

Task: [description]

Plan:
1. [step]
2. [step]

Files: [list]

Risks:
- [risk]: [mitigation]

Rollback: [how to undo]

This is CRITICAL. Proceed? (yes/no)
```

## Output Format

```
FULL WORKFLOW
Task: [description]

THINKER:
Plan: [steps]
Risks: [list]
Rollback: [plan]

[User approved]

BUILDER:
Changes: [list]

TESTER:
Verification: [results]
Tests: [results]

[Final review]

Done. [summary]
```

## Required Elements

- Risk assessment with mitigations
- Rollback plan
- Two user confirmations
- Full test verification

## Time
- Target: 5-15 minutes
- Max: 30+ minutes
