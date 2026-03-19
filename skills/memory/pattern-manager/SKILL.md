---
name: pattern-manager
description: Manage pattern memory using MCP Memory. Save, search, update patterns.
---

# Pattern Manager

Store patterns in MCP Memory as entities.

## Pattern Structure

```json
{
  "name": "Pattern: [name]",
  "entityType": "dev-stacks-pattern",
  "observations": [
    "trigger_keywords: validation, form, login",
    "intent_category: ADD_FEATURE",
    "solution_steps: [1. Create schema, 2. Integrate, 3. Test]",
    "code_example: ...",
    "use_count: 5",
    "success_count: 4",
    "confidence: 0.8",
    "last_used: 2026-03-18T15:00:00Z"
  ]
}
```

## Operations

| Operation | MCP Tool | Action |
|-----------|----------|--------|
| Save | `create_entities` | New pattern |
| Search | `search_nodes` | Find by keywords |
| Update | `add_observations` | Increment stats |
| Delete | `delete_entities` | Remove low confidence |

## Confidence

```
confidence = success_count / use_count
```

| Score | Status |
|-------|--------|
| 0.8+ | Excellent |
| 0.6-0.79 | Good |
| 0.4-0.59 | Fair |
| <0.4 | Poor (delete candidate) |

## Lifecycle

```
Task Success → Extract Pattern → Save → Use → Update Stats → Decay → Delete if <0.3
```

## Output Format

```
PATTERN SEARCH
Query: [keywords]
Found [n] patterns:

1. "[name]" (confidence: 0.xx)
   Keywords: [keywords]
   Used: [n] times
```

## Commands
- `/dev-stacks:learn list` - list patterns
- `/dev-stacks:learn show [name]` - view pattern
- `/dev-stacks:learn delete [name]` - remove pattern
