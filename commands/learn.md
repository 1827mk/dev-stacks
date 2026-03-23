---
description: Chronicler consolidates session learnings into memory — with user confirmation before promoting patterns
argument-hint: [optional: specific topic or pattern to capture]
allowed-tools: Read, Bash, mcp__serena__write_memory, mcp__serena__list_memories, mcp__serena__read_memory, mcp__memory__create_entities, mcp__memory__add_observations, mcp__memory__create_relations, mcp__memory__search_nodes, mcp__memory__read_graph
model: sonnet
---

# dev-stacks: learn

Use the **self-learner** skill, then spawn the **chronicler** agent.

Chronicler will:
1. Collect what was learned this session
2. Write to MCP memory (cross-project) and Serena memory (per-project)
3. Check error-ledger for patterns reaching threshold
4. **Ask user confirmation before promoting any pattern**
5. Report what was written
