---
description: Create a technical implementation plan from a spec or feature description
argument-hint: [spec or feature description]
allowed-tools: Read, Glob, Grep, LS, WebFetch, WebSearch, mcp__serena__find_symbol, mcp__serena__read_file, mcp__serena__get_symbols_overview, mcp__serena__search_for_pattern, mcp__serena__find_file, mcp__serena__list_dir, mcp__serena__list_memories, mcp__serena__read_memory, mcp__context7__resolve-library-id, mcp__context7__get-library-docs, mcp__memory__search_nodes
model: opus
---

# dev-stacks: plan

Spec: $ARGUMENTS

## Steps

1. If spec is vague or incomplete — ask clarifying questions before proceeding:
   - What problem does this solve?
   - What are the acceptance criteria?
   - Any constraints (performance, backward compatibility, deadline)?
   - Wait for answers before writing the plan

2. Use **analyze** skill — trace affected codebase areas

3. Use **design** skill — design the technical approach

4. If external libraries involved — use `mcp__context7__get-library-docs` for current API
   If web research needed — ask user for permission first

5. Produce plan document:

```markdown
# Plan: [feature name]
Date: [ISO date]

## Summary
[2–3 sentences — what this does and why]

## Affected files
| File | Change type | Reason |
|------|-------------|--------|

## Implementation steps
1. [step — file, function, exact change]
2. [step]
...

## Risks
| Risk | Impact | Mitigation |
|------|--------|------------|

## Open questions
- [question — must be answered before starting]

## Definition of done
- [ ] [criterion]
- [ ] All existing tests pass
- [ ] Security review passed
```

6. Save plan to `.dev-stacks/plan.md`

7. Ask user: "Ready to break this into tasks? Run `/dev-stacks:tasks`"
