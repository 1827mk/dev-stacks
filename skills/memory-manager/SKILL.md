---
name: memory-manager
description: Use this skill to view, search, and manage the memory graph — used by /dev-stacks:memory command.
version: 4.0.0
---

# Memory Manager Skill

## View

1. `mcp__memory__read_graph` → get all entities and relations
2. `mcp__serena__list_memories` → list all per-project memories
3. Read `.dev-stacks/error-ledger.jsonl` → count by pattern_key

Present as structured summary:
- MCP entities grouped by type (error-pattern, decision, security-finding)
- Serena memories with dates
- Error patterns with counts and threshold status

## Search

`mcp__memory__search_nodes` with user's query → show matching entities

## Delete (always confirm first)

1. Show exactly what will be deleted
2. Ask: "Delete [name]? yes/no"
3. Only proceed after explicit "yes"
4. Use `mcp__memory__delete_entities` or `mcp__memory__delete_relations`

## Rules

- Never delete without explicit confirmation
- Never modify memory content — only add or delete
- Always show what exists before asking to delete
