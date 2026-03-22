---
name: self-learner
description: Use this skill to analyse error-ledger, check thresholds, and ask user before promoting patterns to instincts or global rules.
version: 4.0.0
---

# Self-Learner Skill

Turn session errors into future instincts — with user confirmation always.

## Process

### 1. Read error-ledger

Read `.dev-stacks/error-ledger.jsonl` — count occurrences per `pattern_key`.

### 2. Read MCP memory

Use `mcp__memory__search_nodes` to find existing entities for same patterns across projects.

### 3. Threshold analysis

| Threshold | Action |
|-----------|--------|
| ≥ 3 same project | Flag as "watch pattern" |
| ≥ 5 same project | Candidate for session instinct |
| ≥ 10 total, 2+ projects | Candidate for global rule |

### 4. Present to user — ALWAYS ask before acting

```
📚 SELF-LEARNER REPORT

Patterns this session:
- [pattern]: [N] occurrences

⚡ Instinct candidates (≥5, same project):
- [pattern] ([N]x) — inject warning at next SessionStart?
  → Reply: yes / no

🌍 Global rule candidates (≥10, 2+ projects):
- [pattern] ([N]x across [M] projects) — write permanent rule?
  → Reply: yes / no
```

### 5. After user confirms

**Instinct approved:** Write pattern to MCP memory with `mcp__memory__create_entities` or `mcp__memory__add_observations`. session-start.sh will pick it up automatically.

**Global rule approved:** Use chronicler to write a markdown rule file to `.dev-stacks/rules/[pattern-name].md` with exact description + example.

**Rejected:** Note in memory that user declined — don't ask again for 30 days.

## Rules

- Never promote without explicit user "yes"
- Never delete memory without explicit user confirmation
- Always show count + context before asking
