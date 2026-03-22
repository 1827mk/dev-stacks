---
description: Architect designs a technical plan — scout + sequential thinking + context7
argument-hint: [spec or feature description]
allowed-tools: Read, Glob, Grep, LS, WebFetch, WebSearch, mcp__serena__find_symbol, mcp__serena__read_file, mcp__serena__get_symbols_overview, mcp__serena__search_for_pattern, mcp__serena__find_file, mcp__serena__list_dir, mcp__serena__list_memories, mcp__serena__read_memory, mcp__serena__check_onboarding_performed, mcp__sequentialthinking__sequentialthinking, mcp__context7__resolve-library-id, mcp__context7__get-library-docs, mcp__memory__search_nodes, mcp__memory__read_graph
model: opus
---

# dev-stacks: think

Spec: $ARGUMENTS

## Steps

1. If spec is vague — ask clarifying questions FIRST. Wait for answers before proceeding:
   - What problem does this solve?
   - Acceptance criteria?
   - Constraints (performance, backward compat, deadline)?

2. Spawn **scout** agent → map affected codebase areas

3. Spawn **architect** agent with scout output → design plan using sequential thinking + context7

4. Save plan to `.dev-stacks/plan.md`

5. Present plan to user. Ask: "Ready to run? Use `/dev-stacks:do` or describe changes first."
