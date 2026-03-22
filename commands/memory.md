---
description: View and manage the memory graph — patterns, decisions, security findings
allowed-tools: Read, Bash, mcp__serena__list_memories, mcp__serena__read_memory, mcp__memory__read_graph, mcp__memory__search_nodes, mcp__memory__delete_entities, mcp__memory__delete_relations
model: haiku
---

# dev-stacks: memory

Show and manage accumulated memory.

## Display

1. Read MCP memory graph: `mcp__memory__read_graph`
2. Read Serena memories: `mcp__serena__list_memories` → read each
3. Read error-ledger: `.dev-stacks/error-ledger.jsonl` — count by pattern

Output:
```
╔══ dev-stacks memory ══════════════════════════╗
  MCP Graph:
  [entity list with observation counts]

  Serena memories:
  [key list with dates]

  Error patterns:
  - [pattern]: [count]x [threshold status]

  Actions:
  • /dev-stacks:learn  — write new learnings
  • /dev-stacks:memory clear [pattern]  — remove pattern
╚════════════════════════════════════════════════╝
```

## Clear (if argument provided)

If user provides pattern name to clear:
- Show what will be deleted
- Ask confirmation: "Delete [pattern] from memory? yes/no"
- Only delete after explicit "yes"
