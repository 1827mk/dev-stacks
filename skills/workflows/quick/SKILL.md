---
name: quick
description: Quick workflow for simple tasks (complexity <0.2). Builder only, skip planning/verification.
---

# Quick Workflow

Simple tasks requiring no planning or verification.

## When to Use
- Complexity: 0.0 - 0.19
- Single file changes
- Typos, comments, style changes
- Documentation updates

## Team
```
Builder only
```

## Process
```
User Input → Builder → Done
```

## Steps

1. **Understand**: What file, what change
2. **Execute**: Direct implementation
3. **Report**: Brief completion

## Output Format

```
QUICK WORKFLOW
Task: [description]

Builder:
- [action taken]

Done. [summary]
```

## Characteristics

| Aspect | Behavior |
|--------|----------|
| Planning | None |
| Confirmation | Never |
| Verification | None |
| Research | If needed |

## Error Handling

| Error | Action |
|-------|--------|
| Recoverable | Auto-fix, retry |
| Retryable | Max 3 retries |
| Blocking | Ask user |

## Time
- Target: <30 seconds
- Max: 2 minutes
