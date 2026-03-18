---
name: complexity-scorer
description: Assess task complexity to determine appropriate workflow. Use after intent detection.
---

# Complexity Scorer

Assesses task complexity to determine which workflow to use.

## Purpose

Calculate a complexity score (0.0-1.0) to route tasks to appropriate workflows.

## Scoring Factors

### 1. Files Affected (weight: 30%)
| Files | Score |
|-------|-------|
| 0-1 files | 0.1 |
| 2-5 files | 0.2 |
| 6+ files | 0.3 |

### 2. Risk Level (weight: 30%)
| Risk | Examples | Score |
|------|----------|-------|
| Low | UI, docs, tests, styling | 0.1 |
| Medium | Business logic, API routes | 0.2 |
| High | Auth, payment, database, security | 0.3 |

### 3. Dependencies (weight: 20%)
| Dependencies | Score |
|--------------|-------|
| Isolated change | 0.0 |
| Affects few modules | 0.1 |
| System-wide impact | 0.2 |

### 4. Reversibility (weight: 20%)
| Reversibility | Score |
|---------------|-------|
| Easy to revert (UI, config) | 0.0 |
| Requires migration | 0.1 |
| Breaking changes | 0.2 |

## Calculation

```
total = files_affected + risk_level + dependencies + reversibility
```

## Workflow Mapping

| Score | Workflow | Description |
|-------|----------|-------------|
| 0.0 - 0.19 | QUICK | Builder only, no confirmation |
| 0.2 - 0.39 | STANDARD | Thinker + Builder |
| 0.4 - 0.59 | CAREFUL | Thinker + Builder + Tester |
| 0.6 - 1.0 | FULL | Full team + user confirmation required |

## Output Format

```json
{
  "score": 0.35,
  "factors": {
    "files_affected": 0.2,
    "risk_level": 0.1,
    "dependencies": 0.05,
    "reversibility": 0.0
  },
  "workflow": "STANDARD",
  "reasoning": "Moderate complexity: affects 3 files, low-risk UI changes, isolated impact",
  "agents": ["thinker", "builder"]
}
```

## Examples

### Example 1: Quick Task
```
Task: Fix typo in README.md

Assessment:
- Files: 1 file → 0.1
- Risk: Documentation → 0.1
- Dependencies: Isolated → 0.0
- Reversibility: Easy → 0.0

Total: 0.2 → QUICK workflow
```

### Example 2: Standard Task
```
Task: Add email validation to login form

Assessment:
- Files: 3 files (form, validation, test) → 0.2
- Risk: Form validation → 0.1
- Dependencies: Affects login module → 0.05
- Reversibility: Easy to revert → 0.0

Total: 0.35 → STANDARD workflow
```

### Example 3: Full Task
```
Task: Implement payment processing

Assessment:
- Files: 8+ files → 0.3
- Risk: Payment (HIGH) → 0.3
- Dependencies: System-wide → 0.2
- Reversibility: Requires migration → 0.1

Total: 0.9 → FULL workflow
```

## Adaptive Adjustment

Claude may adjust the score based on:
- Project DNA (known risk areas)
- Pattern history (similar past tasks)
- User feedback (previous task complexity)

## Usage

Automatically invoked by UserPromptSubmit hook after intent detection.
