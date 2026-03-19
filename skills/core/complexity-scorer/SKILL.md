---
name: complexity-scorer
description: Score task complexity (0.0-1.0) for workflow routing. Auto-invoked by hook.
---

# Complexity Scorer

Calculate complexity score to determine workflow.

## Factors (weight)

| Factor | Low (0.1) | Med (0.2) | High (0.3) |
|--------|-----------|-----------|------------|
| Files | 1 | 2-5 | 6+ |
| Risk | UI/docs | Business logic | Auth/payment/database |
| Dependencies | Isolated | Few modules | System-wide |
| Reversibility | Easy | Migration | Breaking |

## Workflow Mapping

| Score | Workflow | Team |
|-------|----------|------|
| 0.0-0.19 | QUICK | Builder |
| 0.2-0.39 | STANDARD | Thinker + Builder |
| 0.4-0.59 | CAREFUL | Thinker + Builder + Tester |
| 0.6-1.0 | FULL | Full team + user confirm |

## Calculation
```
score = files + risk + dependencies + reversibility
```

## Adaptive
Adjust based on: project DNA, pattern history, user feedback
