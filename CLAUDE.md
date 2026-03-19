# Dev-Stacks Plugin v2.0

Prompt Engineering Gateway for Claude Code.

## Available Skills

| Skill | Use When |
|-------|----------|
| `/dev-stacks:run` | Execute workflow (auto-selects based on complexity) |
| `/dev-stacks:team` | Complex tasks requiring coordinated team |
| `/dev-stacks:research` | Research only, no implementation |
| `/dev-stacks:implement` | Implementation only, skip planning |
| `/dev-stacks:review` | Review existing code |

## Workflow Selection

Hook automatically recommends workflow based on complexity:

| Complexity | Workflow | Agents |
|------------|----------|--------|
| < 0.2 | quick | None (direct) |
| 0.2-0.39 | standard | thinker → builder |
| 0.4-0.59 | careful | thinker → builder → reviewer |
| >= 0.6 | team | lead + 3 reviewers |

## Intent Categories

- FIX_BUG: Bug fixes, error handling
- ADD_FEATURE: New features, implementations
- MODIFY: Changes, refactors
- EXPLAIN: Explanations, documentation
- RESEARCH: Research, analysis
- TEST: Testing, verification
- COMMIT: Git operations

## Files

```
.dev-stacks/
├── state.json      # Current task state
└── registry.json   # Tools database

skills/             # Workflow triggers
agents/             # Subagent definitions
hooks/              # Event handlers
```
