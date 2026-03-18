---
name: pattern-manager
description: Manage pattern memory - save, search, update, and delete patterns using MCP Memory.
---

# Pattern Manager

Manages the pattern memory system using MCP Memory (Knowledge Graph).

## Purpose

Handle all pattern-related operations:
- Save new patterns
- Search for patterns
- Update pattern stats
- Delete old patterns

## Pattern Structure

Patterns are stored in MCP Memory as entities:

```json
{
  "name": "Pattern: [pattern-name]",
  "entityType": "dev-stacks-pattern",
  "observations": [
    "trigger_keywords: [validation, form, login]",
    "intent_category: ADD_FEATURE",
    "solution_steps: [1. Create schema, 2. Integrate, 3. Test]",
    "code_example: ...",
    "use_count: 5",
    "success_count: 4",
    "failure_count: 1",
    "confidence: 0.8",
    "created_at: 2026-03-18T10:00:00Z",
    "last_used_at: 2026-03-18T15:00:00Z"
  ]
}
```

## Operations

### Save Pattern

```
📚 SAVE PATTERN
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Pattern Name: [name]
Trigger Keywords: [keywords]
Intent Category: [category]

Solution Steps:
1. [Step 1]
2. [Step 2]

Code Example:
[Code if any]

Confidence: 1.0 (new pattern)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Save to pattern memory? [Y/n]
```

### Search Patterns

```
📚 PATTERN SEARCH
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Query: [search keywords]

Found [n] patterns:

1. "[Pattern Name]" (confidence: 0.xx)
   Keywords: [keywords]
   Last used: [time] ago
   Used [n] times

2. "[Pattern Name]" (confidence: 0.xx)
   ...
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Update Pattern Stats

After using a pattern:
- Increment `use_count`
- Increment `success_count` or `failure_count`
- Update `confidence = success_count / use_count`
- Update `last_used_at`

### Delete Pattern

When pattern confidence < 0.3 and unused > 30 days:
```
📚 PATTERN CLEANUP
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Removing low-confidence patterns:

- "[Pattern Name]" (confidence: 0.2, unused: 35 days)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## MCP Memory Tools Used

| Tool | Purpose |
|------|---------|
| `mcp__memory__create_entities` | Save new pattern |
| `mcp__memory__search_nodes` | Search patterns |
| `mcp__memory__add_observations` | Update pattern stats |
| `mcp__memory__delete_entities` | Remove patterns |
| `mcp__memory__open_nodes` | Get pattern details |

## Pattern Confidence Formula

```
confidence = success_count / (success_count + failure_count)
```

| Confidence | Status |
|------------|--------|
| 0.8 - 1.0 | Excellent |
| 0.6 - 0.79 | Good |
| 0.4 - 0.59 | Fair |
| 0.0 - 0.39 | Poor (consider deletion) |

## Pattern Lifecycle

```
┌─────────────┐
│ Task Success│
└──────┬──────┘
       │
       ▼
┌─────────────┐
│ Extract     │
│ Pattern     │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│ Save to     │
│ MCP Memory  │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│ Use in      │
│ Future Tasks│
└──────┬──────┘
       │
       ▼
┌─────────────┐
│ Update Stats│
│ (+/-)       │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│ Confidence  │
│ Decay       │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│ Delete if   │
│ < 0.3       │
└─────────────┘
```

## Usage

- Invoked after successful task completion
- Invoked during intent routing for pattern matching
- Invoked by `/ds:learn` command
