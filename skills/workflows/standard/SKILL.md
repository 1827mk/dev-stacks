---
name: standard
description: Standard workflow for moderate tasks (complexity 0.2-0.39). Thinker + Builder pipeline.
---

# Standard Workflow

Moderate tasks requiring planning but not extensive verification.

## When to Use
- Complexity: 0.2 - 0.39
- New features, API implementations
- Multiple file changes
- Business logic changes

## Team
```
Thinker (analyze + plan) → Builder (implement)
```

## Process

```
User Input → Thinker → Builder → Done
```

### Step 1: Thinker
- Analyze requirements
- Research if needed (context7, web_reader)
- Identify files
- Create plan

### Step 2: Builder
- Follow Thinker's plan
- Research APIs if needed
- Implement
- Report changes

## Output Format

```
STANDARD WORKFLOW
Task: [description]

THINKER:
Plan:
1. [step]
2. [step]

BUILDER:
Changes:
- [file]: [change]

Done. [summary]
```

## Error Handling

| Error Type | Action |
|------------|--------|
| Recoverable | Auto-fix and continue |
| Retryable | Retry max 3 times with backoff |
| Planning error | Return to Thinker (max 1 time) |
| Blocking | Ask user: fix/review/rollback/continue |

## Rollback
Use `/dev-stacks:undo` to revert to last checkpoint.

## Notes
- Most common workflow
- Balance of speed and quality
- Can return to Thinker once
