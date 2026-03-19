---
name: review
description: Review-only workflow. Verifies existing implementation without changes.
---

# Dev-Stacks Review

Verification and review only. No code changes.

## Use When

- Code already written
- Need quality check
- Pre-commit review
- Post-implementation verification
- "Check my code"

## Process

1. Read state.json
2. Spawn reviewer subagent
3. Return findings to main context

## Quality Gates

1. Requirements met
2. Tests pass
3. No regressions
4. Code quality acceptable
5. Security check

## Output

```
REVIEW COMPLETE

Requirements: [x/y] met
Tests: [n] run, [n] pass
Quality: [OK/Issues]

Issues Found:
- [issue] (if any)

Result: PASSED / FAILED

Recommendations:
- [recommendation]
```
